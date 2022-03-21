open Lib_common
open Util

let create request =
  let flash_info = Util.Flash_info.fetch request in
  let csrf_token = Dream.csrf_token request in
  let view = View.User.create ?flash_info ~csrf_token () in
  Dream.html @@ from_tyxml view
;;

let login request =
  let flash_info = Util.Flash_info.fetch request in
  let csrf_token = Dream.csrf_token request in
  let view = View.User.login ?flash_info ~csrf_token () in
  Dream.html @@ from_tyxml view
;;

let save request =
  let open Lwt_util in
  let open Model.User.For_registration in
  let* promise =
    let*? post_params = Dream.form ~csrf:true request >|= Try.ok in
    let*? fields = return @@ Try.form post_params in
    let*? user = return @@ from_assoc_list fields in
    Dream.sql request @@ save user
  in
  Result.fold
    ~ok:(fun () ->
      Flash_info.action
        request
        "Utilisateur correctement enregistré. Par contre votre compte n'a \
         probablement pas été activé.";
      Dream.redirect request "/user/login")
    ~error:(fun err ->
      Flash_info.error_tree request err;
      Dream.redirect request "/user/new")
    promise
;;

let auth request =
  let open Lwt_util in
  let open Model.User in
  let* promise =
    let*? post_params = Dream.form ~csrf:true request >|= Try.ok in
    let*? fields = return @@ Try.form post_params in
    let*? user_auth = return @@ For_connection.from_assoc_list fields in
    let*? user = Dream.sql request @@ Saved.get_for_connection user_auth in
    Auth.set_current_user request user
  in
  Result.fold
    ~ok:(fun () ->
      Flash_info.action request "Vous êtes connecté !";
      Dream.redirect request "/")
    ~error:(fun err ->
      Flash_info.error_tree request err;
      Dream.redirect request "/user/login")
    promise
;;

let leave request =
  let open Lwt_util in
  let* () = Dream.invalidate_session request in
  Flash_info.action request "Vous avez été déconneté";
  Dream.redirect request "/user/login"
;;

let is_not_authenticated inner_handler request =
  match Auth.get_connected_user_id request with
  | None -> inner_handler request
  | Some _ ->
    Flash_info.alert request "Vous êtes déjà connecté !";
    Dream.redirect request "/"
;;

let is_authenticated inner_handler request =
  match Auth.get_connected_user_id request with
  | None -> Dream.redirect request "/user/login"
  | Some _ -> inner_handler request
;;

let provide_user inner_handler request =
  let open Lwt_util in
  match Auth.get_connected_user_id request with
  | None ->
    let* () = Dream.invalidate_session request in
    Dream.redirect request "/user/login"
  | Some user_id ->
    let open Model.User.Saved in
    let* promise = Dream.sql request @@ get_by_id user_id in
    Result.fold
      ~ok:(fun user ->
        if is_active user
        then inner_handler user request
        else
          let* () = Dream.invalidate_session request in
          Flash_info.alert request "Vous avez été déconnecté !";
          Dream.redirect request "/user/login")
      ~error:(fun err ->
        let* () = Dream.invalidate_session request in
        Flash_info.error_tree request err;
        Dream.redirect request "/user/login")
      promise
;;
