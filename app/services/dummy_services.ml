open Lib_service
open Util
open Middlewares

let hello_world =
  Service.straight_with
    ~:Endpoints.Global.root
    ~attached:user_required
    [ user_authenticated ]
    (fun user request ->
      let flash_info = Flash_info.fetch request in
      let view = Views.Dummy.hello_world ?flash_info ~user () in
      Dream.html @@ from_tyxml view)
;;
