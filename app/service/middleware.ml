open Lib_service

let not_authenticated fallback inner request =
  match Auth.get_connected_user_id request with
  | None -> inner request
  | Some _ ->
    Flash_info.alert request "Vous êtes déjà connecté";
    Dream.redirect request (Endpoint.href fallback)
;;

let authenticated fallback inner request =
  match Auth.get_connected_user_id request with
  | None -> Dream.redirect request (Endpoint.href fallback)
  | Some _ -> inner request
;;
