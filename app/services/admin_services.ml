open Lib_common
open Lib_service
open Util
open Middlewares

let user =
  Service.failable_with
    ~:Endpoints.Admin.user
    [ user_authenticated ]
    ~attached:administrator_required
    (fun admin request ->
      let open Lwt_util in
      let open Models.User in
      let+? users = Dream.sql request @@ list ~filter:State.moderable Fun.id in
      admin, List.partition is_active users)
    ~succeed:(fun (admin, (active, inactive)) request ->
      let flash_info = Util.Flash_info.fetch request in
      let csrf_token = Dream.csrf_token request in
      let view =
        Views.Admin.users
          ?flash_info
          ~csrf_token
          ~user:admin
          ~active
          ~inactive
          ()
      in
      Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Global.root request)
;;

let user_state_change =
  Service.failable_with
    ~:Endpoints.Admin.user_state_change
    [ user_authenticated ]
    ~attached:administrator_required
    (fun _admin request ->
      let open Lwt_util in
      let open Models.User in
      let*? state_change = handle_form request validate_state_change in
      Dream.sql request @@ update_state state_change)
    ~succeed:(fun () request ->
      Flash_info.action request "L'utilisateur a bien été modifié !";
      redirect_to ~:Endpoints.Admin.user request)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Admin.user request)
;;
