open Lib_common
open Lib_service
open Util
open Middlewares

let login =
  Service.straight
    ~:Endpoints.User.login
    [ user_not_authenticated ]
    (fun request ->
      let flash_info = Flash_info.fetch request in
      let csrf_token = Dream.csrf_token request in
      let view = Views.User.login ?flash_info ~csrf_token () in
      Dream.html @@ from_tyxml view)
;;

let create =
  Service.straight
    ~:Endpoints.User.create
    [ user_not_authenticated ]
    (fun request ->
      let flash_info = Flash_info.fetch request in
      let csrf_token = Dream.csrf_token request in
      let view = Views.User.create ?flash_info ~csrf_token () in
      Dream.html @@ from_tyxml view)
;;

let save =
  Service.failable
    ~:Endpoints.User.save
    [ user_not_authenticated ]
    (fun request ->
      let open Lwt_util in
      let open Models.User in
      let*? user = handle_form request validate_registration in
      Dream.sql request @@ register user)
    ~succeed:(fun () request ->
      Flash_info.action
        request
        "Utilisateur correctement enregistré. Par contre votre compte n'a \
         probablement pas été activé.";
      redirect_to ~:Endpoints.User.login request)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.User.create request)
;;

let auth =
  Service.failable
    ~:Endpoints.User.auth
    [ user_not_authenticated ]
    (fun request ->
      let open Lwt_util in
      let open Models.User in
      let*? user_auth = handle_form request validate_connection in
      let*? user = Dream.sql request @@ get_for_connection user_auth in
      Auth.set_current_user request user)
    ~succeed:(fun () request ->
      Flash_info.action request "Vous êtes connecté !";
      redirect_to ~:Endpoints.Global.root request)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.User.login request)
;;

let leave =
  Service.straight ~:Endpoints.User.leave [ user_authenticated ] (fun request ->
      let open Lwt_util in
      let* () = Dream.invalidate_session request in
      Flash_info.action request "Vous avez été déconneté !";
      redirect_to ~:Endpoints.User.login request)
;;

let list_active =
  Service.failable_with
    ~:Endpoints.User.list
    [ user_authenticated ]
    ~attached:user_required
    (fun user request ->
      let open Lwt_util in
      let open Models.User in
      let+? users = Dream.sql request @@ list ~filter:State.active Fun.id in
      user, users)
    ~succeed:(fun (user, users) request ->
      let flash_info = Util.Flash_info.fetch request in
      let view = Views.User.list_active ?flash_info ~user users () in
      Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Global.root request)
;;
