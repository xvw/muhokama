open Lib_common
open Lib_model
module Db = Lib_db

let list () =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    User.Saved.iter pool (fun user ->
        Logs.info (fun pp ->
            pp
              "%s\t|%s\t|%s\t|%a"
              user.user_id
              user.user_name
              user.user_email
              User.State.pp
              user.user_state))
  in
  Termination.handle promise
;;

let set_user_state user_id user_state =
  let promise =
    let open Lwt_util in
    let*? env = Env.init () in
    let*? pool = Db.connect_with_env env in
    let*? state = Lwt.return (User.State.try_state user_state) in
    User.Saved.change_state pool user_id state
  in
  Termination.handle promise
;;

let action_list =
  let open Cmdliner in
  let doc = "List all user" in
  let exits = Termination.exits in
  Term.(const list $ const (), info "user.list" ~doc ~exits)
;;

let action_set_user_state =
  let open Cmdliner in
  let doc = "Change the state of an user" in
  let exits = Termination.exits in
  Term.(
    ( const set_user_state $ Param.user_id_term $ Param.user_state_term
    , info "user.set-state" ~doc ~exits ))
;;
