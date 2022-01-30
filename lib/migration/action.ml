open Lib_common
open Lib_crypto
module Db = Lib_db

let table = "muhokama_migrations"

let create_migration_table_query =
  Caqti_request.exec
    ~oneshot:true
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
  Caqti_request.exec ~oneshot:true Caqti_type.unit
  @@ Fmt.str "DROP TABLE IF EXISTS %s" table
;;

let drop_migration_table pool =
  let request (module Q : Caqti_lwt.CONNECTION) =
    Q.exec drop_migration_table_query ()
  in
  Db.use pool request
;;

let insert_migration_query =
  Caqti_request.exec ~oneshot:true Caqti_type.(tup2 int string)
  @@ Fmt.str "INSERT INTO %s (number, checksum) VALUES (?, ?)" table
;;

let insert_migration pool index checksum =
  let request (module Q : Caqti_lwt.CONNECTION) =
    Q.exec insert_migration_query (index, Sha256.to_string checksum)
  in
  Db.use pool request
;;

let current_state_query =
  Caqti_request.find_opt
    ~oneshot:true
    Caqti_type.unit
    Caqti_type.(tup2 int string)
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

let warn_on_checksum ctx hash index =
  match Context.check_hash ctx index hash with
  | Ok () -> Logs.debug (fun pp -> pp "Migration already on state [%d]" index)
  | Error _ ->
    Logs.warn (fun pp -> pp "Invalid checksum for migration [%d]" index)
;;

let collapse_queries pool q =
  List.fold_left
    (fun queries query_str ->
      let open Lwt_util in
      let*? () = queries in
      let query = Caqti_request.exec ~oneshot:true Caqti_type.unit query_str in
      let request (module Q : Caqti_lwt.CONNECTION) =
        Q.exec query () >>=? Q.commit
      in
      Db.use pool request)
    (Lwt.return_ok ())
    q
;;

let perform_migrations pool f previous_query (index, migration) =
  let open Lwt_util in
  let q, d =
    Migration.(if f then migration.up, "UP" else migration.down, "DOWN")
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
        let open Migration in
        migration.index, hash migration
      | Some (i, h) -> i, h
    in
    insert_migration pool index checksum
;;

let reset pool _ =
  let open Lwt_util in
  let*? () = drop_migration_table pool in
  let*? () = create_migration_table pool in
  Lwt.return_ok ()
;;

let migrate pool migrations_path target =
  let open Lwt_util in
  let*? () = create_migration_table pool in
  let*? db_index, db_checksum = get_current_state pool in
  let*? migration_ctx = Effect.handle @@ Context.init ~migrations_path in
  let () = Logs.debug (fun pp -> pp "Current migration state [%d]" db_index) in
  let*? step =
    Lwt.return @@ Context.get_migrations ~current:db_index ?target migration_ctx
  in
  match step with
  | Context.Nothing ->
    let () = warn_on_checksum migration_ctx db_checksum db_index in
    Lwt.return_ok ()
  | Context.Up migrations ->
    let*? _ =
      Lwt.return @@ Context.check_hash migration_ctx db_index db_checksum
    in
    let*? _ = process_migration pool None migrations in
    Lwt.return_ok ()
  | Context.Down (migrations, v) ->
    let*? _ = process_migration pool (Some v) migrations in
    Lwt.return_ok ()
;;
