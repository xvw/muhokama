open Lib_common
module Migration_context = Lib_migration.Context
module Db = Lib_db

let reset migrations_path =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    Lib_migration.Action.reset pool migrations_path
  in
  Termination.handle promise
;;

let migrate migrations_path target =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    Lib_migration.Action.migrate pool migrations_path target
  in
  Termination.handle promise
;;

let action_migrate =
  let open Cmdliner in
  let doc = "Migrations are used to modify your database schema over time" in
  let exits = Termination.exits in
  let info = Cmd.info "db.migrate" ~doc ~exits in
  Cmd.v
    info
    Term.(const migrate $ Param.migrations_path_term $ Param.migrate_to_term)
;;

let action_reset =
  let open Cmdliner in
  let doc = "Reset the migration state" in
  let exits = Termination.exits in
  let info = Cmd.info "db.migrate.reset" ~doc ~exits in
  Cmd.v info Term.(const reset $ Param.migrations_path_term)
;;
