open Lib_common
open Lib_crypto

let trim value = value |> String.trim |> String.lowercase_ascii

let hash_password email password =
  Sha256.(hash_string email <|> hash_string password)
;;

module State = struct
  type t =
    | Inactive
    | Member
    | Moderator
    | Admin
    | Unknown of string

  let equal a b =
    match a, b with
    | Inactive, Inactive -> true
    | Member, Member -> true
    | Moderator, Moderator -> true
    | Admin, Admin -> true
    | Unknown a, Unknown b -> String.equal a b
    | _ -> false
  ;;

  let pp ppf = function
    | Inactive -> Fmt.pf ppf "inactive"
    | Member -> Fmt.pf ppf "member"
    | Moderator -> Fmt.pf ppf "moderator"
    | Admin -> Fmt.pf ppf "admin"
    | Unknown s -> Fmt.pf ppf "%s" s
  ;;

  let to_string = Fmt.str "%a" pp

  let try_state state =
    match trim state with
    | "inactive" -> Ok Inactive
    | "member" -> Ok Member
    | "moderator" -> Ok Moderator
    | "admin" -> Ok Admin
    | s -> Error.(to_try @@ user_invalid_state s)
  ;;

  let validate_state state =
    match try_state state with
    | Ok s -> Validate.valid s
    | Error err -> Error.(to_validate err)
  ;;

  let from_string state =
    match trim state with
    | "inactive" -> Inactive
    | "member" -> Member
    | "moderator" -> Moderator
    | "admin" -> Admin
    | s -> Unknown s
  ;;

  let to_int = function
    | Inactive -> 0
    | Member -> 1
    | Moderator -> 2
    | Admin -> 3
    | Unknown _ -> -1
  ;;

  let compare a b =
    let ia = to_int a
    and ib = to_int b in
    Int.compare ia ib
  ;;

  let is_active = function
    | Member | Moderator | Admin -> true
    | Inactive | Unknown _ -> false
  ;;
end

module For_registration = struct
  type t =
    { user_name : string
    ; user_email : string
    ; user_password : Sha256.t
    }

  let user_name_key = "user_name"
  let user_email_key = "user_email"
  let user_password_key = "user_password"
  let confirm_user_password_key = "confirm_user_password"

  let pp ppf { user_name; user_email; user_password = _ } =
    Fmt.pf
      ppf
      "User.For_registration.{ user_name = %a; user_email = %a; user_password \
       = ***  }"
      Fmt.(quote string)
      user_name
      Fmt.(quote string)
      user_email
  ;;

  let equal
      { user_name = a_name; user_email = a_email; user_password = a_password }
      { user_name = b_name; user_email = b_email; user_password = b_password }
    =
    String.equal a_name b_name
    && String.equal a_email b_email
    && Sha256.equal a_password b_password
  ;;

  let make user_name user_email user_password () =
    let user_email = trim user_email
    and user_name = trim user_name
    and user_password =
      Sha256.(hash_string user_email <|> hash_string user_password)
    in
    { user_email; user_name; user_password }
  ;;

  let verify_password password =
    let open Validate in
    let open Assoc.Yojson in
    let message = "min_password_size : 7" in
    password
    |> (string
       & not_blank
       & from_predicate ~message (fun x -> String.length x >= 7))
  ;;

  let from_yojson yojson_obj =
    let open Validate in
    let open Assoc.Yojson in
    object_and
      (fun obj ->
        make
        <$> required (string & not_blank) user_name_key obj
        <*> required (string & is_email) user_email_key obj
        <*> required verify_password user_password_key obj
        <*> ensure_equality user_password_key confirm_user_password_key obj)
      yojson_obj
    |> run ~name:"User.For_registration"
  ;;

  let from_assoc_list query_string =
    query_string |> Assoc.Yojson.from_assoc_list |> from_yojson
  ;;

  let ensure_unicity =
    let query =
      Caqti_request.find
        Caqti_type.(tup2 string string)
        Caqti_type.(tup2 int int)
        "SELECT (SELECT COUNT(*) FROM users WHERE user_name = ?), (SELECT \
         COUNT(*) FROM users WHERE user_email = ?)"
    in
    fun ~user_name ~user_email (module Q : Caqti_lwt.CONNECTION) ->
      let open Lwt_util in
      let*? names, mails =
        Lib_db.try_ @@ Q.find query (user_name, user_email)
      in
      if names > 0 && mails > 0
      then
        return
          Error.(
            to_try @@ user_already_taken ~username:user_name ~email:user_email)
      else if names > 0
      then return Error.(to_try @@ user_name_already_taken user_name)
      else if mails > 0
      then return Error.(to_try @@ user_email_already_taken user_email)
      else return_ok ()
  ;;

  let save =
    let query =
      Caqti_request.exec
        Caqti_type.(tup3 string string string)
        "INSERT INTO users (user_name, user_email, user_password, user_state) \
         VALUES (?, ?, ?, 'inactive')"
    in
    fun { user_name; user_email; user_password }
        (module Q : Caqti_lwt.CONNECTION) ->
      let open Lwt_util in
      let*? () = ensure_unicity ~user_name ~user_email (module Q) in
      Q.exec query (user_name, user_email, Sha256.to_string user_password)
      |> Lib_db.try_
  ;;
end

module For_connection = struct
  type t =
    { user_email : string
    ; user_password : Sha256.t
    }

  let user_email_key = "user_email"
  let user_password_key = "user_password"

  let pp ppf { user_email; user_password = _ } =
    Fmt.pf
      ppf
      "User.For_registration.{ user_email = %a; user_password = ***  }"
      Fmt.(quote string)
      user_email
  ;;

  let equal
      { user_email = a_email; user_password = a_password }
      { user_email = b_email; user_password = b_password }
    =
    String.equal a_email b_email && Sha256.equal a_password b_password
  ;;

  let make user_email user_pasword =
    let user_email = trim user_email
    and user_password = hash_password user_email user_pasword in
    { user_email; user_password }
  ;;

  let from_yojson yojson_obj =
    let open Validate in
    let open Assoc.Yojson in
    object_and
      (fun obj ->
        make
        <$> required (string & is_email) user_email_key obj
        <*> required string user_password_key obj)
      yojson_obj
    |> run ~name:"User.For_connection"
  ;;

  let from_assoc_list query_string =
    query_string |> Assoc.Yojson.from_assoc_list |> from_yojson
  ;;
end

module Saved = struct
  type t =
    { user_id : string
    ; user_name : string
    ; user_email : string
    ; user_state : State.t
    }

  let user_id_key = "user_id"
  let user_email_key = "user_email"
  let user_name_key = "user_name"
  let user_state_key = "user_state"

  let make user_id user_email user_name user_state =
    { user_id; user_email; user_name; user_state }
  ;;

  let make_by_tup4 (user_id, user_name, user_email, user_state) =
    make user_id user_email user_name (State.from_string user_state)
  ;;

  let is_active { user_state; _ } = State.is_active user_state

  let from_yojson yojson_obj =
    let open Validate in
    let open Assoc.Yojson in
    object_and
      (fun obj ->
        make
        <$> required string user_id_key obj
        <*> required (string & is_email) user_email_key obj
        <*> required string user_name_key obj
        <*> required (string & State.validate_state) user_state_key obj)
      yojson_obj
    |> run ~name:"User.For_connection"
  ;;

  let from_assoc_list query_string =
    query_string |> Assoc.Yojson.from_assoc_list |> from_yojson
  ;;

  let equal a b =
    String.equal a.user_id b.user_id
    && String.equal a.user_name b.user_name
    && String.equal a.user_email b.user_email
    && State.equal a.user_state b.user_state
  ;;

  let count =
    let query =
      Caqti_request.find Caqti_type.unit Caqti_type.int
      @@ "SELECT COUNT(*) FROM users"
    in
    fun (module Q : Caqti_lwt.CONNECTION) -> Lib_db.try_ @@ Q.find query ()
  ;;

  let list_active ?(like = "%") callback =
    let query =
      Caqti_request.collect
        Caqti_type.(tup2 string string)
        Caqti_type.(tup4 string string string string)
        "SELECT user_id, user_name, user_email, user_state FROM users WHERE \
         (user_state = 'member' OR user_state = 'moderator' OR user_state = \
         'admin') AND (user_name LIKE ? OR user_email LIKE ?)"
    in
    fun (module Q : Caqti_lwt.CONNECTION) ->
      (* TODO: improvement streaming directly the result *)
      let open Lwt_util in
      let+? list = Lib_db.try_ @@ Q.collect_list query (like, like) in
      List.map
        (fun user ->
          let saved_user = make_by_tup4 user in
          callback saved_user)
        list
  ;;

  let iter =
    let query =
      Caqti_request.collect
        Caqti_type.unit
        Caqti_type.(tup4 string string string string)
        "SELECT user_id, user_name, user_email, user_state FROM users"
    in
    fun callback (module Q : Caqti_lwt.CONNECTION) ->
      Q.iter_s
        query
        (fun user ->
          let saved = make_by_tup4 user in
          Lwt.return_ok @@ callback saved)
        ()
      |> Lib_db.try_
  ;;

  let change_state =
    let query =
      Caqti_request.exec
        ~oneshot:true
        Caqti_type.(tup2 string string)
        "UPDATE users SET user_state = ? WHERE user_id = ?"
    in
    fun ~user_id state (module Q : Caqti_lwt.CONNECTION) ->
      let state_str = State.to_string state in
      Lib_db.try_ @@ Q.exec query (state_str, user_id)
  ;;

  let activate user_id = change_state ~user_id State.Member

  let from_tuple error =
    let open Lwt_util in
    function
    | Some user -> return_ok @@ make_by_tup4 user
    | None -> return @@ Error.to_try error
  ;;

  let get_by_email =
    let query =
      Caqti_request.find_opt
        Caqti_type.(string)
        Caqti_type.(tup4 string string string string)
        ("SELECT user_id, user_name, user_email, user_state FROM users "
        ^ "WHERE user_email = ?")
    in
    fun email (module Q : Caqti_lwt.CONNECTION) ->
      let open Lwt_util in
      let*? potential_user = Lib_db.try_ @@ Q.find_opt query email in
      potential_user |> from_tuple @@ Error.user_not_found email
  ;;

  let get_by_id =
    let query =
      Caqti_request.find_opt
        Caqti_type.(string)
        Caqti_type.(tup4 string string string string)
        ("SELECT user_id, user_name, user_email, user_state FROM users "
        ^ "WHERE user_id = ?")
    in
    fun id (module Q : Caqti_lwt.CONNECTION) ->
      let open Lwt_util in
      let*? potential_user = Lib_db.try_ @@ Q.find_opt query id in
      potential_user |> from_tuple @@ Error.user_id_not_found id
  ;;

  let get_by_email_and_password =
    let query =
      Caqti_request.find_opt
        Caqti_type.(tup2 string string)
        Caqti_type.(tup4 string string string string)
        ("SELECT user_id, user_name, user_email, user_state FROM users "
        ^ "WHERE user_email = ? AND user_password = ?")
    in
    fun ~email ~password (module Q : Caqti_lwt.CONNECTION) ->
      let open Lwt_util in
      let*? potential_user =
        Lib_db.try_ @@ Q.find_opt query (email, password)
      in
      potential_user |> from_tuple @@ Error.user_not_found email
  ;;

  let get_for_connection connection_data db =
    let open Lwt_util in
    let For_connection.{ user_email = email; user_password } =
      connection_data
    in
    let password = Sha256.to_string user_password in
    let*? user = get_by_email_and_password ~email ~password db in
    if State.is_active user.user_state
    then return_ok user
    else return Error.(to_try @@ user_not_activated email)
  ;;

  let pp ppf { user_id; user_name; user_email; user_state } =
    Fmt.pf
      ppf
      "User.Saved { user_id = %a; user_name = %a; user_email = %a; user_state \
       = %a}"
      Fmt.(quote string)
      user_id
      Fmt.(quote string)
      user_name
      Fmt.(quote string)
      user_email
      State.pp
      user_state
  ;;
end
