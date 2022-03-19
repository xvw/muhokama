open Lib_common
open Lib_crypto

let table = "muhokama_migrations"

let create_migration_table =
  let query =
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
  in
  fun (module Q : Caqti_lwt.CONNECTION) -> Lib_db.try_ @@ Q.exec query ()
;;

let drop_migration_table =
  let query =
    Caqti_request.exec ~oneshot:true Caqti_type.unit
    @@ Fmt.str "DROP TABLE IF EXISTS %s" table
  in
  fun (module Q : Caqti_lwt.CONNECTION) -> Lib_db.try_ @@ Q.exec query ()
;;

let insert_migration =
  let query =
    Caqti_request.exec ~oneshot:true Caqti_type.(tup2 int string)
    @@ Fmt.str "INSERT INTO %s (number, checksum) VALUES (?, ?)" table
  in
  fun index checksum (module Q : Caqti_lwt.CONNECTION) ->
    Lib_db.try_ @@ Q.exec query (index, Sha256.to_string checksum)
;;

let get_current_state =
  let query =
    Caqti_request.find_opt
      ~oneshot:true
      Caqti_type.unit
      Caqti_type.(tup2 int string)
    @@ Fmt.str "SELECT number, checksum FROM %s ORDER BY id DESC LIMIT 1" table
  in
  fun (module Q : Caqti_lwt.CONNECTION) ->
    let open Lwt_util in
    let+? result = Lib_db.try_ @@ Q.find_opt query () in
    Option.value ~default:(0, Sha256.(to_string neutral)) result
;;

let warn_on_checksum index hash context =
  match Context.valid_checksum index hash context with
  | Ok () -> ()
  | Error _ ->
    Logs.warn (fun pp -> pp "Invalid checksum for migration [%d]" index)
;;

let compute_migration_query queries db =
  let open Lwt_util in
  List.fold_left
    (fun queries query_str ->
      let query = Caqti_request.exec ~oneshot:true Caqti_type.unit query_str in
      let action (module Q : Caqti_lwt.CONNECTION) = Q.exec query () in
      let*? () = queries in
      Lib_db.try_ @@ action db)
    (return_ok ())
    queries
;;

let perform_migration direction index migration =
  let flag, queries =
    match direction with
    | `Forward -> "forward", migration.Migration.up
    | `Backward _ -> "backward", migration.Migration.down
  in
  let label = migration.label in
  fun (module Q : Caqti_lwt.CONNECTION) ->
    let () =
      Logs.info (fun f -> f "[%s] run migration:%d-%s" flag index label)
    in
    compute_migration_query queries (module Q)
;;

let perform_migrations direction migrations (module Q : Caqti_lwt.CONNECTION) =
  let open Lwt_util in
  let* last_migration =
    List.fold_left
      (fun previous (i, migration) ->
        let*? _ = previous in
        let*? () = Lib_db.try_ @@ Q.start () in
        let*? () = perform_migration direction i migration (module Q) in
        let*? () =
          insert_migration migration.index Migration.(hash migration) (module Q)
        in
        Lib_db.try_ @@ Q.commit ())
      (return_ok ())
      migrations
  in
  match last_migration, direction with
  | Ok (), `Backward (index, hash) -> insert_migration index hash (module Q)
  | Ok (), _ -> return_ok ()
  | Error err, _ ->
    let*? () = Lib_db.try_ @@ Q.rollback () in
    return Error.(to_try err)
;;

let run migration_dir target db =
  let open Lwt_util in
  let*? () = create_migration_table db in
  let*? current_index, current_checksum = get_current_state db in
  let runner = Effect.default_runner @@ Context.init migration_dir in
  let*? context = return runner in
  let () = Logs.info (fun f -> f "Current state [%d]" current_index) in
  let*? plan = return @@ Context.plan ~current:current_index ?target context in
  match plan with
  | Plan.Forward migrations -> perform_migrations `Forward migrations db
  | Plan.Backward (migrations, pair) ->
    perform_migrations (`Backward pair) migrations db
  | Plan.Standby ->
    warn_on_checksum current_index current_checksum context;
    return_ok ()
;;

let reset migration_dir db =
  let open Lwt_util in
  let*? () = run migration_dir (Some 0) db in
  let*? () = drop_migration_table db in
  let*? () = create_migration_table db in
  return_ok ()
;;
