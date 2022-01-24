open Opium
open Lib_ui

let dummy_handler _request =
  let page = Page.dummy in
  Lwt.return @@ Response.of_html page
;;

let routes app =
  app
  |> App.get "/" dummy_handler
  |> App.get "/dummy" dummy_handler
  |> Lwt.return_ok
;;
