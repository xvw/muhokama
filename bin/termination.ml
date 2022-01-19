open Muhokama

let invalid_environment_i = 78
let database_error_i = 126
let unknown_error_i = 1
let invalid_environment = Cmdliner.Term.exit_info ~doc:"Environment error" 78
let database_error = Cmdliner.Term.exit_info ~doc:"Database error" 126
let unknown_error = Cmdliner.Term.exit_info ~doc:"Unregistered error" 1

let exits =
  invalid_environment
  :: database_error
  :: unknown_error
  :: Cmdliner.Term.default_exits
;;

let handle promise =
  match Lwt_main.run promise with
  | Error err ->
    let i =
      match err with
      | Error.Invalid_provider { provider = "env"; _ } -> invalid_environment_i
      | Error.Database _ -> database_error_i
      | _ -> unknown_error_i
    in
    let () = Logs.err (fun pp -> pp "%a" Error.pp err) in
    exit i
  | Ok _ -> exit 0
;;
