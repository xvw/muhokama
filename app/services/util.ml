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

let rec md_map_inline = function
  | Omd.Html (attr, v) -> Omd.Code (attr, v)
  | Omd.Concat (attr, content) ->
    Omd.Concat (attr, List.map md_map_inline content)
  | Omd.Emph (attr, content) -> Omd.Emph (attr, md_map_inline content)
  | Omd.Strong (attr, content) -> Omd.Strong (attr, md_map_inline content)
  | regular_inline -> regular_inline
;;

let rec md_map_block = function
  | Omd.Paragraph (attr, content) -> Omd.Paragraph (attr, md_map_inline content)
  | Omd.Heading (attr, level, content) ->
    Omd.Heading (attr, level, md_map_inline content)
  | Omd.Blockquote (attr, blocks) ->
    Omd.Blockquote (attr, List.map md_map_block blocks)
  | Omd.List (attr, ty, space, blocks) ->
    Omd.List (attr, ty, space, List.map (List.map md_map_block) blocks)
  | Omd.Html_block (attr, v) -> Omd.Code_block (attr, "html", v)
  | regular_block -> regular_block
;;

let markdown_to_html message =
  let doc = Omd.of_string message in
  let new_doc = List.map md_map_block doc in
  Omd.to_html new_doc
;;
