open Lib_common

let launch port =
  let promise =
    let open Lwt_util in
    let+? env = Env.init () in
    App.run ~port env
  in
  Termination.handle promise
;;

let action_launch =
  let open Cmdliner in
  let doc = "Start the muhokama forum" in
  let exits = Termination.exits in
  let info = Cmd.info "server.launch" ~doc ~exits in
  Cmd.v info Term.(const launch $ Param.launching_port_term)
;;
