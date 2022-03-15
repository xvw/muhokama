let run ~port _env =
  Dream.run ~port
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.router [ (Dream.get "/" @@ fun _ -> Dream.html "Hello World") ]
;;
