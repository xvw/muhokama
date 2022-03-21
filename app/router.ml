open Controller

let static = Dream.[ get "/css/**" @@ static "assets/css" ]

let routes =
  Dream.
    [ scope
        "/" (* Connected scope *)
        [ User.is_authenticated ]
        [ scope "/user" [] [ get "/leave" User.leave ]
        ; get "/" @@ User.provide_user Dummy.hello_world
        ]
    ; scope
        "/"
        [ Controller.User.is_not_authenticated ]
        [ scope (* Not connected scope *)
            "/user"
            []
            [ get "/new" User.create
            ; get "/login" User.login
            ; post "/new" User.save
            ; post "/auth" User.auth
            ]
        ]
    ]
  @ static
;;
