open Lib_common
open Util
open Lib_service

let user_authenticated inner_handler request =
  match Auth.get_connected_user_id request with
  | None -> redirect_to ~:Endpoints.User.login request
  | Some _ -> inner_handler request
;;

let user_not_authenticated inner_handler request =
  match Auth.get_connected_user_id request with
  | None -> inner_handler request
  | Some _ ->
    Flash_info.alert request "Vous êtes déjà connecté !";
    redirect_to ~:Endpoints.Global.root request
;;

let user_required inner_handler request =
  let open Lwt_util in
  match Auth.get_connected_user_id request with
  | None ->
    let* () = Dream.invalidate_session request in
    redirect_to ~:Endpoints.User.login request
  | Some user_id ->
    let open Models.User in
    let* promise = Dream.sql request @@ get_by_id user_id in
    Result.fold
      ~ok:(fun user ->
        if is_active user
        then inner_handler user request
        else
          let* () = Dream.invalidate_session request in
          Flash_info.alert request "Vous avez été déconnecté !";
          redirect_to ~:Endpoints.User.login request)
      ~error:(fun err ->
        let* () = Dream.invalidate_session request in
        Flash_info.error_tree request err;
        redirect_to ~:Endpoints.User.login request)
      promise
;;

let as_moderator inner_handler user request =
  let open Models.User in
  match user.state with
  | State.Admin | State.Moderator -> inner_handler user request
  | _ -> redirect_to ~:Endpoints.Global.root request
;;

let as_administrator inner_handler user request =
  let open Models.User in
  match user.state with
  | State.Admin -> inner_handler user request
  | _ -> redirect_to ~:Endpoints.Global.root request
;;

let moderator_required inner_handler =
  user_required @@ as_moderator inner_handler
;;

let administrator_required inner_handler =
  user_required @@ as_administrator inner_handler
;;
