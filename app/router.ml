open Lib_service
module S = Service
module C = Controller

let perform next_handler request =
  let uri = Dream.target request
  and meth = Dream.method_ request in
  Endpoint.(
    decide
      [ ~:S.User.login >> C.User.login
      ; ~:S.User.create >> C.User.create
      ; ~:S.User.save >> C.User.save
      ; ~:S.User.auth >> C.User.auth
      ; ~:S.User.leave >> C.User.leave
      ; (~:S.User.list >> C.User.(provide_user list_active))
      ; (~:S.Global.root >> C.(User.provide_user Dummy.hello_world))
      ; (~:S.User.moderables >> C.User.(provide_administrator list_moderable))
      ; (~:S.User.state_change >> C.User.(provide_administrator state_change))
      ]
      meth
      uri
      next_handler
      request)
;;

let static = Dream.(router [ get "/css/**" @@ static "assets/css" ])
