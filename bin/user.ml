open Lib_common

let list () =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Lib_db.connect env in
    Lib_db.use pool
    @@ Models.User.iter (fun user ->
           Logs.info (fun pp ->
               pp
                 "%s\t|%s\t|%s\t|%a"
                 user.id
                 user.name
                 user.email
                 Models.User.State.pp
                 user.state))
  in
  Termination.handle promise
;;

let set_user_state user_id user_state =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Lib_db.connect env in
    let*? state = Lwt.return (Models.User.State.try_state user_state) in
    Lib_db.use pool @@ Models.User.change_state ~user_id state
  in
  Termination.handle promise
;;

let action_list =
  let open Cmdliner in
  let doc = "List all user" in
  let exits = Termination.exits in
  let info = Cmd.info "user.list" ~doc ~exits in
  Cmd.v info Term.(const list $ const ())
;;

let action_set_user_state =
  let open Cmdliner in
  let doc = "Change the state of an user" in
  let exits = Termination.exits in
  let info = Cmd.info "user.set-state" ~doc ~exits in
  Cmd.v
    info
    Term.(const set_user_state $ Param.user_id_term $ Param.user_state_term)
;;
