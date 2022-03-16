module Main = struct
  let inbox = "muhokama-notification"

  let process request notif =
    let flash_message = notif |> Lib_ui.Notif.serialize in
    Dream.add_flash_message request inbox flash_message
  ;;

  let action request message = process request @@ Lib_ui.Notif.Action message
  let info request message = process request @@ Lib_ui.Notif.Info message
  let alert request message = process request @@ Lib_ui.Notif.Alert message

  let error_tree request error =
    let tree = Lib_common.Error.normalize error in
    process request @@ Lib_ui.Notif.Error_tree tree
  ;;

  let nothing request = process request Lib_ui.Notif.Nothing

  let fetch request =
    request
    |> Dream.flash_messages
    |> List.assoc_opt inbox
    |> Option.map Lib_ui.Notif.unserialize
  ;;
end
