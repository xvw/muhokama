open Lib_common
open Util

let create request =
  let flash_info = Service.Flash_info.fetch request in
  let csrf_token = Dream.csrf_token request in
  let view = View.User.create ?flash_info ~csrf_token () in
  Dream.html @@ from_tyxml view
;;

let login request =
  let flash_info = Service.Flash_info.fetch request in
  let csrf_token = Dream.csrf_token request in
  let view = View.User.login ?flash_info ~csrf_token () in
  Dream.html @@ from_tyxml view
;;

let save request =
  let open Lwt_util in
  let open Model.User in
  let* promise =
    let*? user = handle_form request validate_registration in
    Dream.sql request @@ register user
  in
  let open Lib_service in
  Result.fold
    ~ok:(fun () ->
      Service.Flash_info.action
        request
        "Utilisateur correctement enregistré. Par contre votre compte n'a \
         probablement pas été activé.";
      Dream.redirect request @@ Endpoint.href ~:Service.User.login)
    ~error:(fun err ->
      Service.Flash_info.error_tree request err;
      Dream.redirect request @@ Endpoint.href ~:Service.User.create)
    promise
;;

let auth request =
  let open Lwt_util in
  let open Model.User in
  let* promise =
    let*? user_auth = handle_form request validate_connection in
    let*? user = Dream.sql request @@ get_for_connection user_auth in
    Service.Auth.set_current_user request user
  in
  let open Lib_service in
  Result.fold
    ~ok:(fun () ->
      Service.Flash_info.action request "Vous êtes connecté !";
      Dream.redirect request @@ Endpoint.href ~:Service.Global.root)
    ~error:(fun err ->
      Service.Flash_info.error_tree request err;
      Dream.redirect request @@ Endpoint.href ~:Service.User.login)
    promise
;;

let leave request =
  let open Lwt_util in
  let open Lib_service in
  let* () = Dream.invalidate_session request in
  Service.Flash_info.action request "Vous avez été déconneté";
  Dream.redirect request @@ Endpoint.href ~:Service.User.login
;;

let list_active user request =
  let open Lwt_util in
  let open Model.User in
  let* promise = Dream.sql request @@ list ~filter:State.active Fun.id in
  let open Lib_service in
  Result.fold
    ~ok:(fun users ->
      let flash_info = Service.Flash_info.fetch request in
      let _csrf_token = Dream.csrf_token request in
      let view = View.User.list_active ?flash_info ~user users () in
      Dream.html @@ from_tyxml view)
    ~error:(fun err ->
      Service.Flash_info.error_tree request err;
      Dream.redirect request @@ Endpoint.href ~:Service.Global.root)
    promise
;;

let list_moderable user request =
  let open Lwt_util in
  let open Model.User in
  let* promise = Dream.sql request @@ list ~filter:State.moderable Fun.id in
  let open Lib_service in
  Result.fold
    ~ok:(fun users ->
      let active, inactive = List.partition is_active users in
      let flash_info = Service.Flash_info.fetch request in
      let csrf_token = Dream.csrf_token request in
      let view =
        View.User.list_moderable
          ?flash_info
          ~csrf_token
          ~user
          ~active
          ~inactive
          ()
      in
      Dream.html @@ from_tyxml view)
    ~error:(fun err ->
      Service.Flash_info.error_tree request err;
      Dream.redirect request @@ Endpoint.href ~:Service.Global.root)
    promise
;;

let state_change _ request =
  let open Lwt_util in
  let open Model.User in
  let* promise =
    let*? state_change = handle_form request validate_state_change in
    Dream.sql request @@ update_state state_change
  in
  let open Lib_service in
  Result.fold
    ~ok:(fun () ->
      Service.Flash_info.action request "L'utilisateur a bien été modifié !";
      Dream.redirect request @@ Endpoint.href ~:Service.User.moderables)
    ~error:(fun err ->
      Service.Flash_info.error_tree request err;
      Dream.redirect request @@ Endpoint.href ~:Service.User.moderables)
    promise
;;

let is_not_authenticated inner_handler request =
  match Service.Auth.get_connected_user_id request with
  | None -> inner_handler request
  | Some _ ->
    let open Lib_service in
    Service.Flash_info.alert request "Vous êtes déjà connecté !";
    Dream.redirect request @@ Endpoint.href ~:Service.Global.root
;;

let is_authenticated inner_handler request =
  let open Lib_service in
  match Service.Auth.get_connected_user_id request with
  | None -> Dream.redirect request @@ Endpoint.href ~:Service.User.login
  | Some _ -> inner_handler request
;;

let provide_user inner_handler request =
  let open Lwt_util in
  let open Lib_service in
  match Service.Auth.get_connected_user_id request with
  | None ->
    let* () = Dream.invalidate_session request in
    Dream.redirect request @@ Endpoint.href ~:Service.User.login
  | Some user_id ->
    let open Model.User in
    let* promise = Dream.sql request @@ get_by_id user_id in
    Result.fold
      ~ok:(fun user ->
        if is_active user
        then inner_handler user request
        else
          let* () = Dream.invalidate_session request in
          Service.Flash_info.alert request "Vous avez été déconnecté !";
          Dream.redirect request @@ Endpoint.href ~:Service.User.login)
      ~error:(fun err ->
        let* () = Dream.invalidate_session request in
        Service.Flash_info.error_tree request err;
        Dream.redirect request @@ Endpoint.href ~:Service.User.login)
      promise
;;

let as_moderator inner_handler user request =
  let open Model.User in
  let open Lib_service in
  match user.state with
  | State.Admin | State.Moderator -> inner_handler user request
  | _ -> Dream.redirect request @@ Endpoint.href ~:Service.Global.root
;;

let as_administrator inner_handler user request =
  let open Model.User in
  let open Lib_service in
  match user.state with
  | State.Admin -> inner_handler user request
  | _ -> Dream.redirect request @@ Endpoint.href ~:Service.Global.root
;;

let provide_moderator inner_handler = provide_user @@ as_moderator inner_handler

let provide_administrator inner_handler =
  provide_user @@ as_administrator inner_handler
;;
