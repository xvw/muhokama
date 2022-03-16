open Lib_common
open Lib_ui

let dummy_handler request =
  let flash = Flash.Main.fetch request in
  let page = Page.dummy ?flash () in
  Dream.html @@ Render.to_raw_html page
;;

module Registration = struct
  let create request =
    let flash = Flash.Main.fetch request in
    let csrf_token = Dream.csrf_token request in
    let page = Page.register ?flash ~csrf_token () in
    Dream.html @@ Render.to_raw_html page
  ;;

  let may_store request =
    Dream.sql request (fun db ->
        let open Lwt_util in
        let open Lib_model.User.Pre_saved in
        let promise =
          let*? raw_params = Dream.form ~csrf:true request >|= Try.ok in
          let*? raw_fields = return @@ Try.form raw_params in
          let*? user = return @@ from_assoc_list raw_fields in
          save db user
        in
        promise
        >>= function
        | Ok () ->
          let () = Flash.Main.action request "User properly saved" in
          Dream.redirect request "/"
        | Error err ->
          let () = Flash.Main.error_tree request err in
          Dream.redirect request "/register/")
  ;;

  let scope =
    Dream.scope "/register" [] Dream.[ get "/" create; post "/new" may_store ]
  ;;
end

let static = Dream.[ get "/css/**" @@ static "assets/css" ]
let routes = Dream.[ get "/" dummy_handler; Registration.scope ] @ static
