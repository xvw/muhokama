open Lib_common

let from_tyxml doc = doc |> Fmt.str "%a" (Tyxml.Html.pp ())

let handle_form ?(csrf = true) request formlet =
  let open Lwt_util in
  let*? params = Dream.form ~csrf request >|= Try.ok in
  let*? fields = return @@ Try.form params in
  return @@ formlet fields
;;

let redirect_to = Lib_service.Endpoint.redirect

module Flash_info = struct
  module Model = Models.Flash_info

  let inbox = "muhokama-notification"

  let fallback request =
    request
    |> Dream.flash_messages
    |> List.assoc_opt inbox
    |> Option.fold ~none:() ~some:(Dream.add_flash_message request inbox)
  ;;

  let process request notif =
    let flash_message = notif |> Model.serialize in
    Dream.add_flash_message request inbox flash_message
  ;;

  let action request message = process request @@ Model.Action message
  let info request message = process request @@ Model.Info message
  let alert request message = process request @@ Model.Alert message

  let error_tree request error =
    let tree = Lib_common.Error.normalize error in
    process request @@ Model.Error_tree tree
  ;;

  let nothing request = process request Model.Nothing

  let fetch request =
    request
    |> Dream.flash_messages
    |> List.assoc_opt inbox
    |> Option.map Model.unserialize
  ;;
end

module Auth = struct
  let inbox = "muhokama-user-id"

  let set_current_user request user =
    let open Lwt_util in
    let Models.User.{ id; _ } = user in
    let* () = Dream.set_session_field request inbox id in
    return_ok ()
  ;;

  let get_connected_user_id request = Dream.session_field request inbox
end
