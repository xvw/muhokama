let call = Sys.argv.(0)
let version = "dev"

let program =
  let open Cmdliner in
  let doc = "Muhokama dev tool" in
  let sdocs = Manpage.s_common_options in
  let exits = Term.default_exits in
  ( Term.(ret (const (`Help (`Pager, None))))
  , Term.info call ~version ~doc ~sdocs ~exits )
;;

let subprograms =
  [ Db_migrate.action_migrate; Db_migrate.action_reset; Server.action_launch ]
;;

let () =
  let () = Logs.set_reporter (Logs_fmt.reporter ()) in
  let () = Logs.set_level (Some Logs.Debug) in
  Cmdliner.(Term.exit @@ Term.eval_choice program subprograms)
;;
