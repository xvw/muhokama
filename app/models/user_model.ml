open Lib_common
open Lib_crypto
open Util
module State = User_state
open Caqti_request.Infix
open Caqti_type.Std

type t =
  { id : string
  ; name : string
  ; email : string
  ; state : State.t
  }

type registration_form =
  { registration_name : string
  ; registration_email : string
  ; registration_password : Sha256.t
  }

type connection_form =
  { connection_email : string
  ; connection_password : Sha256.t
  }

type state_change_form =
  { state_change_id : string
  ; state_change_action : action
  }

and action =
  | Upgrade
  | Downgrade

let from_tuple (id, name, email, state) =
  { id; name; email; state = State.from_string state }
;;

let from_tuple_with_error err =
  Option.fold
    ~none:Error.(Lwt.return @@ to_try err)
    ~some:Preface.Fun.(Lwt.return_ok % from_tuple)
;;

let report_non_integrity_violation =
  let query =
    (tup2 string string ->! tup2 int int)
      {sql|
          SELECT
            (SELECT COUNT(*) FROM users WHERE user_name = ?),
            (SELECT COUNT(*) FROM users WHERE user_email = ?)
      |sql}
  in
  fun ~name ~email (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? ns, ms = Lib_db.try_ @@ Db.find query (name, email) in
    match ns, ms with
    | 0, 0 -> return_ok ()
    | _, 0 -> return Error.(to_try @@ user_name_already_taken name)
    | 0, _ -> return Error.(to_try @@ user_email_already_taken email)
    | _, _ -> return Error.(to_try @@ user_already_taken ~username:name ~email)
;;

let register =
  let query =
    (tup3 string string string ->. unit)
      {sql|
          INSERT INTO users (
            user_name,
            user_email,
            user_password,
            user_state
          )
          VALUES (?, ?, ?, 'inactive')
      |sql}
  in
  fun { registration_name = name
      ; registration_email = email
      ; registration_password = password
      }
      (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? () = report_non_integrity_violation ~name ~email (module Db) in
    let password = Sha256.to_string password in
    Db.exec query (name, email, password) |> Lib_db.try_
;;

let count ?(filter = State.all) =
  let query =
    (unit ->! int)
    @@ Fmt.str
         {sql|
           SELECT COUNT(*) FROM users WHERE (%a)
         |sql}
         (State.pp_filter ())
         filter
  in
  fun (module Db : Lib_db.T) -> Lib_db.try_ @@ Db.find query ()
;;

let list ?(filter = State.all) ?(like = "%") callback =
  let query =
    (tup2 string string ->* tup4 string string string string)
    @@ Fmt.str
         {sql|
           SELECT
             user_id,
             user_name,
             user_email,
             user_state
           FROM users
           WHERE (%a)
             AND (user_name LIKE ? OR user_email LIKE ?)
           ORDER BY user_name
         |sql}
         (State.pp_filter ())
         filter
  in
  fun (module Db : Lib_db.T) ->
    (* TODO: improvement streaming directly the result *)
    let open Lwt_util in
    let+? list = Lib_db.try_ @@ Db.collect_list query (like, like) in
    List.map Preface.Fun.(callback % from_tuple) list
;;

let iter =
  let query =
    (unit ->* tup4 string string string string)
      {sql|
          SELECT
            user_id,
            user_name,
            user_email,
            user_state
         FROM users
      |sql}
  in
  fun callback (module Db : Lib_db.T) ->
    Db.iter_s query Preface.Fun.(Lwt.return_ok % callback % from_tuple) ()
    |> Lib_db.try_
;;

let change_state =
  let query =
    (tup2 string string ->. unit)
      ~oneshot:true
      {sql|
          UPDATE users
          SET user_state = ?
          WHERE user_id = ?
      |sql}
  in
  fun ~user_id state (module Db : Lib_db.T) ->
    let state_str = State.to_string state in
    Lib_db.try_ @@ Db.exec query (state_str, user_id)
;;

let activate user_id = change_state ~user_id State.Member

let get_by_email =
  let query =
    (string ->? tup4 string string string string)
      {sql|
          SELECT
            user_id,
            user_name,
            user_email,
            user_state
          FROM users
          WHERE user_email = ?
      |sql}
  in
  fun email (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? potential_user = Lib_db.try_ @@ Db.find_opt query email in
    potential_user |> from_tuple_with_error @@ Error.user_not_found email
;;

let get_by_id =
  let query =
    (string ->? tup4 string string string string)
      {sql|
          SELECT
            user_id,
            user_name,
            user_email,
            user_state
          FROM users
          WHERE user_id = ?
      |sql}
  in
  fun id (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? potential_user = Lib_db.try_ @@ Db.find_opt query id in
    potential_user |> from_tuple_with_error @@ Error.user_id_not_found id
;;

let get_by_email_and_password =
  let query =
    (tup2 string string ->? tup4 string string string string)
      {sql|
          SELECT
            user_id,
            user_name,
            user_email,
            user_state
          FROM users
          WHERE user_email = ?
            AND user_password = ?
      |sql}
  in
  fun email pass (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? potential_user = Lib_db.try_ @@ Db.find_opt query (email, pass) in
    potential_user |> from_tuple_with_error @@ Error.user_not_found email
;;

let get_for_connection
  { connection_email = email; connection_password = password }
  db
  =
  let open Lwt_util in
  let password = Sha256.to_string password in
  let*? user = get_by_email_and_password email password db in
  if State.is_active user.state
  then return_ok user
  else return Error.(to_try @@ user_not_activated email)
;;

let compute_new_state action state =
  match state, action with
  | State.Admin, _ -> Error.(to_try user_is_admin)
  | State.(Inactive | Unknown _), Downgrade ->
    Error.(to_try user_already_inactive)
  | State.(Inactive | Unknown _), Upgrade -> Ok State.Member
  | State.Member, Downgrade -> Ok State.Inactive
  | State.Member, Upgrade -> Ok State.Moderator
  | State.Moderator, Downgrade -> Ok State.Member
  | State.Moderator, Upgrade -> Ok State.Admin
;;

let update_state { state_change_id = user_id; state_change_action = action } db =
  let open Lwt_util in
  let*? user = get_by_id user_id db in
  let*? new_state = return @@ compute_new_state action user.state in
  change_state ~user_id:user.id new_state db
;;

let required_password ~password_field source =
  let open Lib_form in
  let message = "the password must contain at least 7 characters"
  and check_length x = String.length x >= 7 in
  required
    source
    password_field
    (not_blank &> from_predicate ~message check_length)
;;

let validate_registration
  ?(name_field = "user_name")
  ?(email_field = "user_email")
  ?(password_field = "user_password")
  ?(confirm_password_field = "confirm_user_password")
  =
  let open Lib_form in
  let formlet s =
    let+ name = required s name_field not_blank
    and+ email = required s email_field (is_email $ normalize_name)
    and+ password = required_password ~password_field s
    and+ () = ensure_equality s password_field confirm_password_field in
    { registration_name = name
    ; registration_email = email
    ; registration_password = hash_password ~email ~password
    }
  in
  run ~name:"User.registration" formlet
;;

let validate_connection
  ?(email_field = "user_email")
  ?(password_field = "user_password")
  =
  let open Lib_form in
  let formlet s =
    let+ email = required s email_field (is_email $ normalize_name)
    and+ password = required s password_field is_string in
    { connection_email = email
    ; connection_password = hash_password ~email ~password
    }
  in
  run ~name:"User.connection" formlet
;;

let is_action x =
  match normalize_name x with
  | "upgrade" -> Validate.valid Upgrade
  | "downgrade" -> Validate.valid Downgrade
  | given_value ->
    let target_type = "Downgrade | Upgrade" in
    let error =
      Error.validation_unconvertible_string ~given_value ~target_type
    in
    Error.to_validate error
;;

let validate_state_change ?(id_field = "user_id") ?(action_field = "action") =
  let open Lib_form in
  let formlet s =
    let+ id = required s id_field is_uuid
    and+ action = required s action_field is_action in
    { state_change_id = id; state_change_action = action }
  in
  run ~name:"User.state_change" formlet
;;

let equal
  { id = id_a; name = name_a; email = email_a; state = state_a }
  { id = id_b; name = name_b; email = email_b; state = state_b }
  =
  String.equal id_a id_b
  && String.equal name_a name_b
  && String.equal email_a email_b
  && State.equal state_a state_b
;;

let pp ppf { id; name; email; state } =
  let quoted = Fmt.(quote string) in
  Fmt.pf
    ppf
    "User { id = %a; name = %a; email = %a; state = %a }"
    quoted
    id
    quoted
    name
    quoted
    email
    State.pp
    state
;;

let is_active { state; _ } = State.is_active state
