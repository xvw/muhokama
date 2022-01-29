module M = Middleware
open Opium
open Lib_common
open Lib_ui
open Lib_model

let dummy_handler _request =
  let page = Page.dummy () in
  Lwt.return @@ Response.of_html page
;;

let register_handler _request =
  let page = Page.register () in
  Lwt.return @@ Response.of_html page
;;

let register_new_handler request =
  let open Lwt_util in
  let open User.Pre_saved in
  let promise =
    let*? data = Request.to_urlencoded request >|= Result.ok in
    let pool = M.pool request in
    let*? user = from_urlencoded data |> Lwt.return in
    save pool user
  in
  promise
  >|= function
  | Ok () ->
    let page = Page.dummy ~notifs:(Notif.Action "User properly saved") () in
    Response.of_html page
  | Error err ->
    let tree = Error.normalize err in
    let page = Page.register ~notifs:(Notif.Error_tree tree) () in
    Response.of_html ~headers:Headers.empty page
;;

let routes app =
  app
  |> App.get "/" dummy_handler
  |> App.get "/register" register_handler
  |> App.post "/register/new" register_new_handler
  |> App.get "/dummy" dummy_handler
  |> Lwt.return_ok
;;
