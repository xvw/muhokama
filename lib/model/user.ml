open Lib_common
open Lib_crypto

let count_query =
  Caqti_request.find Caqti_type.unit Caqti_type.int
  @@ "SELECT COUNT(*) FROM users"
;;

let count pool =
  let request (module Q : Caqti_lwt.CONNECTION) = Q.find count_query () in
  Lib_db.use pool request
;;

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

module Pre_saved = struct
  type t =
    { user_name : string
    ; user_email : string
    ; user_password : Sha256.t
    }

  let make user_name user_email user_password () =
    let user_email = trim user_email in
    let user_name = trim user_name in
    { user_name
    ; user_email
    ; user_password =
        Sha256.(hash_string user_email <|> hash_string user_password)
    }
  ;;

  let formlet =
    ( ("user_name", `Text)
    , ("user_email", `Email)
    , ("user_password", `Password)
    , ("confirm_user_password", `Password) )
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

  let create yojson_obj =
    let open Validate in
    let open Assoc.Yojson in
    object_and
      (fun obj ->
        make
        <$> required (string & not_blank) "user_name" obj
        <*> required (string & is_email) "user_email" obj
        <*> required verify_password "user_password" obj
        <*> ensure_equality "user_password" "confirm_user_password" obj)
      yojson_obj
    |> run ~name:"User.Pre_saved"
  ;;

  let from_urlencoded query_string =
    query_string |> Assoc.Yojson.from_urlencoded |> create
  ;;

  let count_query =
    Caqti_request.find
      Caqti_type.(tup2 string string)
      Caqti_type.(tup2 int int)
      "SELECT (SELECT COUNT(*) FROM users WHERE user_name = ?), (SELECT \
       COUNT(*) FROM users WHERE user_email = ?)"
  ;;

  let count_for pool ~username ~email =
    let request (module Q : Caqti_lwt.CONNECTION) =
      Q.find count_query (username, email)
    in
    let open Lwt_util in
    let*? names, mails = Lib_db.use pool request in
    if names > 0 && mails > 0
    then Lwt.return_error @@ Error.user_already_taken ~username ~email
    else if names > 0
    then Lwt.return_error @@ Error.user_name_already_taken username
    else if mails > 0
    then Lwt.return_error @@ Error.user_email_already_taken email
    else Lwt.return_ok ()
  ;;

  let save_query =
    Caqti_request.exec
      Caqti_type.(tup3 string string string)
      "INSERT INTO users (user_name, user_email, user_password, user_state) \
       VALUES (?, ?, ?, 'inactive')"
  ;;

  let save pool { user_name; user_email; user_password } =
    let request (module Q : Caqti_lwt.CONNECTION) =
      Q.exec save_query (user_name, user_email, Sha256.to_string user_password)
    in
    let open Lwt_util in
    let*? () = count_for pool ~username:user_name ~email:user_email in
    Lib_db.use pool request
  ;;
end

module Saved = struct
  type t =
    { user_id : string
    ; user_name : string
    ; user_email : string
    ; user_state : State.t
    }

  let list_query =
    Caqti_request.collect
      Caqti_type.unit
      Caqti_type.(tup4 string string string string)
      "SELECT user_id, user_name, user_email, user_state FROM users"
  ;;

  let chanage_state_query =
    Caqti_request.exec
      ~oneshot:true
      Caqti_type.(tup2 string string)
      "UPDATE users SET user_state = ? WHERE user_id = ?"
  ;;

  let change_state pool user_id state =
    let state_str = State.to_string state in
    let request (module Q : Caqti_lwt.CONNECTION) =
      Q.exec chanage_state_query (state_str, user_id)
    in
    Lib_db.use pool request
  ;;

  let activate pool user_id = change_state pool user_id State.Member

  let iter pool callback =
    let request (module Q : Caqti_lwt.CONNECTION) =
      Q.iter_s
        list_query
        (fun (user_id, user_name, user_email, user_state) ->
          let saved =
            { user_id
            ; user_name
            ; user_email
            ; user_state = State.from_string user_state
            }
          in
          Lwt.return_ok @@ callback saved)
        ()
    in
    Lib_db.use pool request
  ;;
end
