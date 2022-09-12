open Lib_common

type t = Caqti_lwt.connection

module type T = Caqti_lwt.CONNECTION

let try_ request_expr =
  let open Lwt_util in
  request_expr
  >>= function
  | Ok result -> return_ok result
  | Error err ->
    let message = Caqti_error.show err in
    return Error.(to_try @@ Database message)
;;

let make_uri_with ~user ~password ~host ~port ~database =
  Format.asprintf "postgresql://%s:%s@%s:%d/%s" user password host port database
  |> Uri.of_string
;;

let connect_with ~max_size ~user ~password ~host ~port ~database =
  let uri = make_uri_with ~user ~password ~host ~port ~database in
  (match Caqti_lwt.connect_pool ~max_size uri with
   | Ok pool -> Try.ok pool
   | Error err ->
     let message = Caqti_error.show err in
     Error.to_try @@ Database message)
  |> Lwt.return
;;

let make_uri env =
  let open Env in
  make_uri_with
    ~host:env.pgsql_host
    ~port:env.pgsql_port
    ~user:env.pgsql_user
    ~password:env.pgsql_pass
    ~database:env.pgsql_db
;;

let connect env =
  let open Env in
  connect_with
    ~max_size:env.pgsql_connection_pool
    ~host:env.pgsql_host
    ~port:env.pgsql_port
    ~user:env.pgsql_user
    ~password:env.pgsql_pass
    ~database:env.pgsql_db
;;

let use pool callback =
  let exception Capturable_failure of Error.t in
  let open Lwt_util in
  let promise () =
    try_
      (Caqti_lwt.Pool.use
         (fun db ->
           let* result = callback db in
           (* It's a bit of a sad hack but at the moment I can't think of
              a better approach (unless you create a [Lib_db.Try] that
              extends a [`Execution_error of Error.t] variant but
              I'm not sure that's better...  *)
           match result with
           | Ok x -> return_ok x
           | Error err -> raise (Capturable_failure err))
         pool)
  in
  let catch_handler = function
    | Capturable_failure err -> return @@ Error.to_try err
    | _ -> return @@ Error.(to_try @@ Database "Unknown error")
    (* Should not happen. *)
  in
  Lwt.catch promise catch_handler
;;

let transaction callback (module Db : T) =
  let open Lwt_util in
  let* task =
    let*? () = try_ @@ Db.start () in
    let*? result = callback () in
    let+? () = try_ @@ Db.commit () in
    result
  in
  match task with
  | Ok result -> return_ok result
  | Error err ->
    let*? () = try_ @@ Db.rollback () in
    return @@ Error err
;;
