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

let action_list =
  let open Cmdliner in
  let doc = "List all user" in
  let exits = Termination.exits in
  Term.(const list $ const (), info "user.list" ~doc ~exits)
;;
