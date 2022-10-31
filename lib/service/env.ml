let show_value = Fmt.str "%a" Lib_common.Env.pp
let env_field = Dream_pure.Message.new_field ~show_value ()
let log = Dream__server.Log.sub_log "muhokama.env"

let set env =
  let cell = ref None in
  fun inner_handler request ->
    match !cell with
    | Some env ->
      Dream_pure.Message.set_field request env_field env;
      inner_handler request
    | None ->
      cell := Some env;
      Dream_pure.Message.set_field request env_field env;
      inner_handler request
;;

let get request callback =
  match Dream_pure.Message.field request env_field with
  | None ->
    let message = "Env is not properly set" in
    log.error (fun log -> log ~request "%s" message);
    failwith message
  | Some env -> callback env
;;
