open Lib_common

type 'a connection =
  (Caqti_lwt.connection, ([> Caqti_error.connect ] as 'a)) Caqti_lwt.Pool.t

let make_uri ~user ~password ~host ~port ~database =
  Format.asprintf "postgresql://%s:%s@%s:%d/%s" user password host port database
  |> Uri.of_string
;;

let connect ~max_size ~user ~password ~host ~port ~database =
  let uri = make_uri ~user ~password ~host ~port ~database in
  (match Caqti_lwt.connect_pool ~max_size uri with
  | Ok pool -> Try.ok pool
  | Error err ->
    let message = Caqti_error.show err in
    Try.error @@ Error.Database message)
  |> Lwt.return
;;

let connect_with_env ?(test = false) env =
  let open Env in
  let database = if test then env.pgsql_db_test else env.pgsql_db_dev in
  connect
    ~max_size:env.pgsql_connection_pool
    ~host:env.pgsql_host
    ~port:env.pgsql_port
    ~user:env.pgsql_user
    ~password:env.pgsql_pass
    ~database
;;

let as_try obj =
  let open Lwt_util in
  obj
  >>= function
  | Ok result -> return @@ Try.ok result
  | Error err ->
    let message = Caqti_error.show err in
    return (Try.error @@ Error.Database message)
;;

let use pool f = Caqti_lwt.Pool.use f pool |> as_try
