open Lib_service
open Util

let root =
  Service.straight ~:Endpoints.Global.root [] (fun request ->
    Flash_info.fallback request;
    Util.redirect_to ~:Endpoints.Topic.root request)
;;

let error =
  Service.straight ~:Endpoints.Global.error [] (fun request ->
    let flash_info = Flash_info.fetch request in
    let view = Views.Global.error ?flash_info () in
    Dream.html @@ from_tyxml view)
;;
