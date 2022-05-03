open Controllers

let static = Dream.[ get "/css/**" @@ static "assets/css" ]

let routes =
  Dream.
    [ scope
        "/" (* Connected scope *)
        [ User.is_authenticated ]
        [ scope
            "/user"
            []
            [ get "/leave" User.leave
            ; get "/list" @@ User.provide_user User.list_active
            ]
        ; scope
            "/admin"
            []
            [ get "/user" @@ User.provide_administrator User.list_moderable
            ; post "/user/state" @@ User.provide_administrator User.state_change
            ]
        ; get "/" @@ User.provide_user Dummy.hello_world
        ]
    ; scope
        "/"
        [ User.is_not_authenticated ]
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
