open Lib_common

let trim value = value |> String.trim |> String.lowercase_ascii

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
end

module For_registration = struct
  open Lib_crypto

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
    fun (module Q : Caqti_lwt.CONNECTION) ~user_name ~user_email ->
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
    fun (module Q : Caqti_lwt.CONNECTION)
        { user_name; user_email; user_password } ->
      let open Lwt_util in
      let*? () = ensure_unicity (module Q) ~user_name ~user_email in
      Q.exec query (user_name, user_email, Sha256.to_string user_password)
      |> Lib_db.try_
  ;;
end
