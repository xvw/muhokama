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

let read_migration path =
  let open Try in
  let* content = Io.read_file path in
  Yaml.of_string content |> Result.map_error (function `Msg e -> Error.Yaml e)
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
      let files = Io.read_dir migrations_path in
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

let migrate () =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    let*? () = create_migration_table pool in
    let*? _migration_ctx =
      handle @@ M.Context.init ~migrations_path:"./migrations"
    in
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
