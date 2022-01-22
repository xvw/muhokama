open Lib_common
module M = Lib_migration
module Db = Lib_db

let table = "muhokama_migrations"

let create_migration_table_query =
  Caqti_request.exec Caqti_type.unit
  @@ Format.asprintf
       {sql|CREATE TABLE IF NOT EXISTS %s (
         id SERIAL NOT NULL PRIMARY KEY,
         number INTEGER NOT NULL UNIQUE,
         checksum TEXT NOT NULL) |sql}
       table
;;

let create_migration_table pool =
  let request (module Q : Caqti_lwt.CONNECTION) =
    Q.exec create_migration_table_query ()
  in
  Db.use pool request
;;

let handle program =
  let handler : type a. (a -> 'b) -> a M.Effect.f -> 'b =
   fun resume -> function
    | Fetch_migrations { migrations_path } ->
      resume @@ Io.read_dir migrations_path
    | Warning message ->
      let () = Logs.warn (fun pp -> pp "%s" message) in
      resume ()
    | Error err -> Try.error (Error.Migration_context_error err)
  in
  M.Effect.run { handler } program
;;

let migrate () =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    let*? () = create_migration_table pool in
    Lwt.return_ok ()
  in
  Termination.handle promise
;;

let action =
  let open Cmdliner in
  let doc = "Migrations are used to modify your database schema over time" in
  let exits = Termination.exits in
  Term.(const migrate $ const (), info "db.migrate" ~doc ~exits)
;;
