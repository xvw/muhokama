(* open Lib_common *)
open Lib_ui

let dummy_handler _request =
  let page = Page.dummy () in
  Dream.html @@ Render.to_raw_html page
;;

module Registration = struct
  let create _request =
    let page = Page.register () in
    Dream.html @@ Render.to_raw_html page
  ;;

  let scope = Dream.scope "/register" [] Dream.[ get "/" create ]
end

let static = Dream.[ get "/css/**" @@ static "assets/css" ]
let routes = Dream.[ get "/" dummy_handler; Registration.scope ] @ static
