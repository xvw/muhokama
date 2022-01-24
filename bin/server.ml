open Lib_common

let launch port =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    Lib_server.run ~port env
  in
  Termination.handle promise
;;

let action_launch =
  let open Cmdliner in
  let doc = "Start the muhokama forum" in
  let exits = Termination.exits in
  Term.(
    const launch $ Param.launching_port_term, info "server.launch" ~doc ~exits)
;;
