open Lib_common
open Lib_crypto
module Migration_context = Lib_migration.Context
module Db = Lib_db

let table = "muhokama_migrations"

let read_migration path =
  let open Try in
  let* content = Io.read_file path in
  Yaml.of_string content |> Result.map_error (function `Msg e -> Error.Yaml e)
;;

let handle program =
  let handler : type a. (a -> 'b) -> a Lib_migration.Effect.f -> 'b =
   fun resume -> function
    | Fetch_migrations { migrations_path } ->
      let files = Io.list_files migrations_path in
      resume files
    | Read_migration { filepath } ->
      let migration_obj = read_migration filepath in
      resume migration_obj
    | Info message ->
      let () = Logs.debug (fun pp -> pp "%s" message) in
      resume ()
    | Warning message ->
      let () = Logs.warn (fun pp -> pp "%s" message) in
      resume ()
    | Error err ->
      let x = Error.Migration_context_error err in
      Try.error x
  in
  Lib_migration.Effect.run { handler } program |> Lwt.return
;;

let create_migration_table_query =
  Caqti_request.exec
    Caqti_type.unit
    ([ "CREATE TABLE IF NOT EXISTS "
     ; table
     ; " (id SERIAL NOT NULL PRIMARY KEY,"
     ; "number INTEGER NOT NULL ,"
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

let insert_migration_query =
  Caqti_request.exec Caqti_type.(tup2 int string)
  @@ Fmt.str "INSERT INTO %s (number, checksum) VALUES (?, ?)" table
;;

let insert_migration pool index checksum =
  let request (module Q : Caqti_lwt.CONNECTION) =
    Q.exec insert_migration_query (index, Sha256.to_string checksum)
  in
  Db.use pool request
;;

let current_state_query =
  Caqti_request.find_opt Caqti_type.unit Caqti_type.(tup2 int string)
  @@ Fmt.str "SELECT number, checksum FROM %s ORDER BY id DESC LIMIT 1" table
;;

let get_current_state pool =
  let open Lwt_util in
  let request (module Q : Caqti_lwt.CONNECTION) =
    Q.find_opt current_state_query ()
  in
  let+? opt = Db.use pool request in
  Option.value ~default:(0, Sha256.(to_string neutral)) opt
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

let warn_on_checksum ctx hash index =
  match Migration_context.check_hash ctx index hash with
  | Ok () -> Logs.debug (fun pp -> pp "Migration already on state [%d]" index)
  | Error _ ->
    Logs.warn (fun pp -> pp "Invalid checksum for migration [%d]" index)
;;

let collapse_queries pool q =
  List.fold_left
    (fun queries query_str ->
      let open Lwt_util in
      let*? () = queries in
      let query = Caqti_request.exec Caqti_type.unit query_str in
      let request (module Q : Caqti_lwt.CONNECTION) = Q.exec query () in
      Db.use pool request)
    (Lwt.return_ok ())
    q
;;

let perform_migrations pool f previous_query (index, migration) =
  let open Lwt_util in
  let q, d =
    Lib_migration.Migration.(
      if f then migration.up, "UP" else migration.down, "DOWN")
  in
  let () = Logs.debug (fun pp -> pp "[%s] %d. %s" d index migration.label) in
  let*? _ = previous_query in
  let+? () = collapse_queries pool q in
  Some migration
;;

let process_migration pool opt migrations =
  let f = Option.is_none opt in
  let open Lwt_util in
  let*? last_played_migration =
    List.fold_left (perform_migrations pool f) (Lwt.return_ok None) migrations
  in
  match last_played_migration with
  | None -> Lwt.return_ok ()
  | Some migration ->
    let index, checksum =
      match opt with
      | None ->
        let open Lib_migration.Migration in
        migration.index, hash migration
      | Some (i, h) -> i, h
    in
    insert_migration pool index checksum
;;

let migrate migrations_path target =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    let*? () = create_migration_table pool in
    let*? db_index, db_checksum = get_current_state pool in
    let*? migration_ctx = handle @@ Migration_context.init ~migrations_path in
    let () =
      Logs.debug (fun pp -> pp "Current migration state [%d]" db_index)
    in
    let*? step =
      Lwt.return
      @@ Migration_context.get_migrations
           ~current:db_index
           ?target
           migration_ctx
    in
    match step with
    | Migration_context.Nothing ->
      let () = warn_on_checksum migration_ctx db_checksum db_index in
      Lwt.return_ok ()
    | Migration_context.Up migrations ->
      let*? _ =
        Lwt.return
        @@ Migration_context.check_hash migration_ctx db_index db_checksum
      in
      let*? _ = process_migration pool None migrations in
      Lwt.return_ok ()
    | Migration_context.Down (migrations, v) ->
      let*? _ = process_migration pool (Some v) migrations in
      Lwt.return_ok ()
  in
  Termination.handle promise
;;

let action_migrate =
  let open Cmdliner in
  let doc = "Migrations are used to modify your database schema over time" in
  let exits = Termination.exits in
  Term.(
    ( const migrate $ Param.migrations_path_term $ Param.migrate_to_term
    , info "db.migrate" ~doc ~exits ))
;;

let action_reset =
  let open Cmdliner in
  let doc = "Reset the migration state" in
  let exits = Termination.exits in
  Term.(
    ( const reset $ Param.migrations_path_term
    , info "db.migrate.reset" ~doc ~exits ))
;;
