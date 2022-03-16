open Lib_common

let sql_pool env =
  let size = env.Env.pgsql_connection_pool in
  let uri = Lib_db.make_uri env in
  let str = Uri.to_string uri in
  Dream.sql_pool ~size str
;;

let run ~port env =
  Dream.run ~port
  @@ Dream.logger
  @@ sql_pool env
  @@ Dream.sql_sessions
  @@ Dream.memory_sessions
  @@ Dream.router Router.routes
;;
