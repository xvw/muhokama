open Lib_common

let inbox = "muhokama-user-id"

let set_current_user request user =
  let open Lwt_util in
  let Model.User.{ id; _ } = user in
  let* () = Dream.set_session_field request inbox id in
  return_ok ()
;;

let get_connected_user_id request = Dream.session_field request inbox
