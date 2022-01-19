open Muhokama

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

let migrate () =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    create_migration_table pool
  in
  Termination.handle promise
;;

let action =
  let open Cmdliner in
  let doc = "Migrations are used to modify your database schema over time" in
  let exits = Termination.exits in
  Term.(const migrate $ const (), info "db.migrate" ~doc ~exits)
;;
