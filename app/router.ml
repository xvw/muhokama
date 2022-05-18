let static = Dream.(router [ get "/css/**" @@ static "assets/css" ])

let choose_service next_handler request =
  let uri = Dream.target request
  and method_ = Dream.method_ request in
  Lib_service.Service.choose
    method_
    uri
    [ Services.User.login
    ; Services.User.create
    ; Services.User.save
    ; Services.User.auth
    ; Services.User.leave
    ; Services.User.list_active
    ; Services.Topic.create
    ; Services.Topic.save
    ; Services.Topic.answer
    ; Services.Topic.list
    ; Services.Topic.list_by_category
    ; Services.Topic.show
    ; Services.Admin.root
    ; Services.Admin.user
    ; Services.Admin.user_state_change
    ; Services.Admin.category
    ; Services.Admin.new_category
    ; Services.Global.error
    ; Services.Global.root
    ]
    next_handler
    request
;;
