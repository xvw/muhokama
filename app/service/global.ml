open Lib_service

let root () = Endpoint.get (fun () -> Path.root) [] ()
