open Lib_common
module M = Lib_migration
module Db = Lib_db

let table = "muhokama_migrations"

let read_migration path =
  let open Try in
  let* content = Io.read_file path in
  Yaml.of_string content |> Result.map_error (function `Msg e -> Error.Yaml e)
;;

let handle program =
  let handler : type a. (a -> 'b) -> a M.Effect.f -> 'b =
   fun resume -> function
    | Fetch_migrations { migrations_path } ->
      let files = Io.list_files migrations_path in
      resume files
    | Read_migration { filepath } ->
      let migration_obj = read_migration filepath in
      resume migration_obj
    | Info message ->
      let () = Logs.info (fun pp -> pp "%s" message) in
      resume ()
    | Warning message ->
      let () = Logs.warn (fun pp -> pp "%s" message) in
      resume ()
    | Error err ->
      let x = Error.Migration_context_error err in
      Try.error x
  in
  M.Effect.run { handler } program |> Lwt.return
;;

let create_migration_table_query =
  Caqti_request.exec
    Caqti_type.unit
    ([ "CREATE TABLE IF NOT EXISTS "
     ; table
     ; " (id SERIAL NOT NULL PRIMARY KEY,"
     ; "number INTEGER NOT NULL UNIQUE,"
     ; "checksum TEXT NOT NULL)"
     ]
    |> String.concat "")
;;

let create_migration_table pool =
  let request (module Q : Caqti_lwt.CONNECTION) =
    Q.exec create_migration_table_query ()
  in
  Db.use pool request
;;

let drop_migration_table_query =
  Caqti_request.exec Caqti_type.unit @@ Fmt.str "DROP TABLE IF EXISTS %s" table
;;

let drop_migration_table pool =
  let request (module Q : Caqti_lwt.CONNECTION) =
    Q.exec drop_migration_table_query ()
  in
  Db.use pool request
;;

let current_state_query =
  Caqti_request.find_opt Caqti_type.unit Caqti_type.int
  @@ Fmt.str "SELECT number FROM %s ORDER BY id DESC LIMIT 1" table
;;

let get_current_state pool =
  let open Lwt_util in
  let request (module Q : Caqti_lwt.CONNECTION) =
    Q.find_opt current_state_query ()
  in
  let+? opt = Db.use pool request in
  Option.value ~default:0 opt
;;

let reset _migrations_path =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    let*? () = drop_migration_table pool in
    let*? () = create_migration_table pool in
    Lwt.return_ok ()
  in
  Termination.handle promise
;;

let migrate migrations_path =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    let*? () = create_migration_table pool in
    let*? db_migration_state = get_current_state pool in
    let*? migration_ctx = handle @@ M.Context.init ~migrations_path in
    let ctx_migration_state = M.Context.current_state migration_ctx in
    let () =
      Logs.info (fun pp -> pp "%d - %d" db_migration_state ctx_migration_state)
    in
    Lwt.return_ok ()
  in
  Termination.handle promise
;;

let action_migrate =
  let open Cmdliner in
  let doc = "Migrations are used to modify your database schema over time" in
  let exits = Termination.exits in
  Term.(
    const migrate $ Param.migrations_path_term, info "db.migrate" ~doc ~exits)
;;

let action_reset =
  let open Cmdliner in
  let doc = "Reset the migration state" in
  let exits = Termination.exits in
  Term.(
    ( const reset $ Param.migrations_path_term
    , info "db.migrate.reset" ~doc ~exits ))
;;
