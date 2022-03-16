let static = Dream.[ get "/css/**" @@ static "assets/css" ]
let routes = Dream.[ get "/" Controller.Dummy.hello_world ] @ static
