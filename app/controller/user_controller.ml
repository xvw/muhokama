open Lib_common
open Util

let create request =
  let flash_info = Util.Flash_info.fetch request in
  let csrf_token = Dream.csrf_token request in
  let view = View.User.create ?flash_info ~csrf_token () in
  Dream.html @@ from_tyxml view
;;

let save request =
  let open Lwt_util in
  let open Model.User.For_registration in
  let promise =
    let*? post_params = Dream.form ~csrf:true request >|= Try.ok in
    let*? fields = return @@ Try.form post_params in
    let*? user = return @@ from_assoc_list fields in
    Dream.sql request @@ save user
  in
  let* result = promise in
  match result with
  | Ok () ->
    Flash_info.action request "Utilisateur correctement enregistré";
    Dream.redirect request "/"
  | Error err ->
    Flash_info.error_tree request err;
    Dream.redirect request "/user/new"
;;
