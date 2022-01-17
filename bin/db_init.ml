open Muhokama

let table = "muhokama_migrations"

let init_query =
  Caqti_request.exec Caqti_type.unit
  @@ Format.asprintf
       {sql|CREATE TABLE IF NOT EXISTS %s (
         id SERIAL NOT NULL PRIMARY KEY,
         number INTEGER NOT NULL UNIQUE,
         checksum TEXT NOT NULL) |sql}
       table
;;

let perform_init pool =
  let query (module Query : Caqti_lwt.CONNECTION) = Query.exec init_query () in
  Caqti_lwt.Pool.use query pool |> Db.as_try
;;

let init () =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Env.connect_to_db env in
    let () = Logs.info (fun pp -> pp "Initializing [%s]" table) in
    perform_init pool
  in
  match Lwt_main.run promise with
  | Error exn ->
    let n =
      match exn with
      | Exn.List _ -> 1
      | Exn.Database _ -> 2
      | _ -> 3
    in
    let () = Logs.err (fun pp -> pp "%a\n---\n%a" Exn.pp exn Exn.pp_desc exn) in
    exit n
  | Ok () ->
    let () =
      Logs.info (fun pp -> pp "[%s] is created (or already present)" table)
    in
    exit 0
;;

let action =
  let open Cmdliner in
  let doc = Format.asprintf "Create table [%s] if it does not exist" table in
  let exits =
    let invalid_env =
      let doc = "Invalid environment" in
      Term.exit_info ~doc 1
    and error_db =
      let doc = "An error on the DB side" in
      Term.exit_info ~doc 2
    and unknown_error =
      let doc = "Unknown error" in
      Term.exit_info ~doc 3
    in
    invalid_env :: error_db :: unknown_error :: Term.default_exits
  in
  Term.(const init $ const (), info "db.init" ~doc ~exits)
;;
