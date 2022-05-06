open Lib_common

let sql_pool env =
  env
  |> Lib_db.make_uri
  |> Uri.to_string
  |> Dream.sql_pool ~size:env.Env.pgsql_connection_pool
;;

let run ~port env =
  Dream.run ~port
  @@ Dream.logger
  @@ sql_pool env
  @@ Dream.sql_sessions
  @@ Dream.flash
  @@ Router.choose_service
  @@ Router.static
;;
