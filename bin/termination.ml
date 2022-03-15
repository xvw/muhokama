open Lib_common

let invalid_environment_i = 78
let migration_context_i = 79
let database_error_i = 126
let unknown_error_i = 1

let invalid_environment =
  Cmdliner.Cmd.Exit.info ~doc:"Environment error" invalid_environment_i
;;

let migration_context =
  Cmdliner.Cmd.Exit.info ~doc:"Environment error" migration_context_i
;;

let database_error =
  Cmdliner.Cmd.Exit.info ~doc:"Database error" database_error_i
;;

let unknown_error =
  Cmdliner.Cmd.Exit.info ~doc:"Unregistered error" unknown_error_i
;;

let exits =
  invalid_environment
  :: migration_context
  :: database_error
  :: unknown_error
  :: Cmdliner.Cmd.Exit.defaults
;;

let handle promise =
  match Lwt_main.run promise with
  | Error err ->
    let i =
      match err with
      | Error.Invalid_object { name = "env"; _ } -> invalid_environment_i
      | Error.Migration _ -> migration_context_i
      | Error.Database _ -> database_error_i
      | _ -> unknown_error_i
    in
    let () = Logs.err (fun pp -> pp "%a" Error.pp err) in
    exit i
  | Ok _ -> exit 0
;;
