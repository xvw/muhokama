let call = Sys.argv.(0)
let version = "dev"

let subprograms =
  [ Db_migrate.action_migrate
  ; Db_migrate.action_reset
  ; Server.action_launch
  ; User.action_list
  ; User.action_set_user_state
  ]
;;

let program =
  let open Cmdliner in
  let doc = "Muhokama dev tool" in
  let sdocs = Manpage.s_common_options in
  let exits = Cmd.Exit.defaults in
  let info = Cmd.info call ~version ~doc ~sdocs ~exits in
  let default = Term.(ret (const (`Help (`Pager, None)))) in
  Cmd.group info ~default subprograms
;;

let () =
  let () = Logs.set_reporter (Logs_fmt.reporter ()) in
  let () = Logs.set_level (Some Logs.Debug) in
  exit @@ Cmdliner.Cmd.eval program
;;
