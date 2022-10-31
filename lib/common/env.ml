type t =
  { pgsql_host : string
  ; pgsql_port : int
  ; pgsql_db : string
  ; pgsql_user : string
  ; pgsql_pass : string
  ; pgsql_connection_pool : int
  ; log_level : Logs.level
  ; notification_hook : string option
  }

let string_to_log log =
  let open Validate in
  match String.lowercase_ascii log with
  | "debug" -> valid Logs.Debug
  | "info" -> valid Logs.Info
  | "warning" -> valid Logs.Warning
  | "error" -> valid Logs.Error
  | "app" -> valid Logs.App
  | unknown -> Error.(to_validate @@ io_invalid_loglevel unknown)
;;

let equal a b =
  String.equal a.pgsql_host b.pgsql_host
  && Int.equal a.pgsql_port b.pgsql_port
  && String.equal a.pgsql_db b.pgsql_db
  && String.equal a.pgsql_user b.pgsql_user
  && String.equal a.pgsql_pass b.pgsql_pass
  && Int.equal a.pgsql_connection_pool b.pgsql_connection_pool
  && String.equal
       (Logs.level_to_string (Some a.log_level))
       (Logs.level_to_string (Some b.log_level))
  && Option.equal String.equal a.notification_hook b.notification_hook
;;

let pp_aux
  pp_h
  ppf
  { pgsql_host
  ; pgsql_port
  ; pgsql_db
  ; pgsql_connection_pool
  ; pgsql_user
  ; pgsql_pass
  ; log_level
  ; notification_hook
  }
  =
  Format.fprintf
    ppf
    "{pgsql = \"postgresql://%s:%a@%s:%d/%s\"; pool = %d; log_level = %a; \
     notification_hook = %a}"
    pgsql_user
    pp_h
    pgsql_pass
    pgsql_host
    pgsql_port
    pgsql_db
    pgsql_connection_pool
    Logs.pp_level
    log_level
    (Preface.Option.pp pp_h)
    notification_hook
;;

let pp = pp_aux (fun ppf _ -> Format.fprintf ppf "***")

let make_environment
  pgsql_host
  pgsql_port
  pgsql_db
  pgsql_connection_pool
  pgsql_user
  pgsql_pass
  log_level
  notification_hook
  =
  { pgsql_host
  ; pgsql_port
  ; pgsql_db
  ; pgsql_connection_pool
  ; pgsql_user
  ; pgsql_pass
  ; log_level
  ; notification_hook
  }
;;

let validate =
  let open Validate in
  let open Free in
  make_environment
  <$> required string "POSTGRESQL_ADDON_HOST"
  <*> required (int & bounded_to 1 65535) "POSTGRESQL_ADDON_PORT"
  <*> required string "POSTGRESQL_ADDON_DB"
  <*> (optional int "POSTGRESQL_ADDON_CONNECTION_POOL" >? 5)
  <*> required string "POSTGRESQL_ADDON_USER"
  <*> required string "POSTGRESQL_ADDON_PASSWORD"
  <*> (optional string_to_log "LOG_LEVEL" >? Logs.Info)
  <*> optional string "SLACK_NOTIFICATION_WEBHOOK"
;;

let init () =
  Lwt.return @@ Validate.Free.run ~name:"env" Sys.getenv_opt validate
;;
