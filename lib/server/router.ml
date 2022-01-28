open Opium
open Lib_common
open Lib_ui

let dummy_handler _request =
  let page = Page.dummy in
  Lwt.return @@ Response.of_html page
;;

let register_handler _request =
  let page = Page.register in
  Lwt.return @@ Response.of_html page
;;

let register_new_handler request =
  let open Lwt_util in
  let open Lib_model.User.Pre_saved in
  let+ data = Request.to_urlencoded request in
  let user = from_urlencoded data in
  let response =
    match user with
    | Error e -> `Assoc [ "error", `String (Fmt.str "%a" Error.pp e) ]
    | Ok _ -> `Assoc []
  in
  Response.of_json response
;;

let routes app =
  app
  |> App.get "/" dummy_handler
  |> App.get "/register" register_handler
  |> App.post "/register/new" register_new_handler
  |> App.get "/dummy" dummy_handler
  |> Lwt.return_ok
;;
