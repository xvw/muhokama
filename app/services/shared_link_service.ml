open Lib_common
open Lib_service
open Util
open Middlewares

let root =
  Service.straight_with
    ~:Endpoints.Shared_link.root
    ~attached:user_required
    [ user_authenticated ]
    (fun user request ->
    let flash_info = Flash_info.fetch request in
    let csrf_token = Dream.csrf_token request in
    let view = Views.Shared_link.root ?flash_info ~csrf_token ~user () in
    Dream.html @@ from_tyxml view)
;;

let create =
  Service.failable_with
    ~:Endpoints.Shared_link.create
    ~attached:user_required
    [ user_authenticated ]
    (fun user request ->
      let open Lwt_util in
      let open Models.Shared_link in
      let*? creation_form = handle_form request validate_creation in
      Dream.sql request @@ create creation_form user)
    ~succeed:(fun _ request ->
      Flash_info.action request "Lien correctement partagé";
      redirect_to ~:Endpoints.Shared_link.root request)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Shared_link.root request)
;;
