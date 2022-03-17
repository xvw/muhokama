let static = Dream.[ get "/css/**" @@ static "assets/css" ]

let routes =
  Dream.
    [ scope
        "/user"
        []
        [ get "/new" Controller.User.create; post "/new" Controller.User.save ]
    ; get "/" Controller.Dummy.hello_world
    ]
  @ static
;;
