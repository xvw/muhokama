open Lib_service

let login () =
  Endpoint.get
    (fun () -> Path.(!"user" / "login"))
    Middleware.[ not_authenticated ~:Global.root ]
    ()
;;

let create () =
  Endpoint.get
    (fun () -> Path.(!"user" / "new"))
    Middleware.[ not_authenticated ~:Global.root ]
    ()
;;

let save () =
  Endpoint.post
    (fun () -> Path.(!"user" / "new"))
    Middleware.[ not_authenticated ~:Global.root ]
    ()
;;

let auth () =
  Endpoint.post
    (fun () -> Path.(!"user" / "auth"))
    Middleware.[ not_authenticated ~:Global.root ]
    ()
;;

let leave () =
  Endpoint.get
    (fun () -> Path.(!"user" / "leave"))
    Middleware.[ authenticated ~:login ]
    ()
;;

let list () =
  Endpoint.get
    (fun () -> Path.(!"user" / "list"))
    Middleware.[ authenticated ~:login ]
    ()
;;

let moderables () =
  Endpoint.get
    (fun () -> Path.(!"admin" / "user"))
    Middleware.[ authenticated ~:login ]
    ()
;;

let state_change () =
  Endpoint.post
    (fun () -> Path.(!"admin" / "user" / "state"))
    Middleware.[ authenticated ~:login ]
    ()
;;
