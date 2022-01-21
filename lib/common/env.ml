type t =
  { pgsql_host : string
  ; pgsql_port : int
  ; pgsql_db_dev : string
  ; pgsql_db_test : string
  ; pgsql_user : string
  ; pgsql_pass : string
  ; pgsql_connection_pool : int
  ; log_level : Logs.level
  }

let string_to_log log =
  let open Validate in
  match String.lowercase_ascii log with
  | "debug" -> valid Logs.Debug
  | "info" -> valid Logs.Info
  | "warning" -> valid Logs.Warning
  | "error" -> valid Logs.Error
  | "app" -> valid Logs.App
  | unknown -> Error.(to_validate @@ Invalid_log_level unknown)
;;

let equal a b =
  String.equal a.pgsql_host b.pgsql_host
  && Int.equal a.pgsql_port b.pgsql_port
  && String.equal a.pgsql_db_test b.pgsql_db_test
  && String.equal a.pgsql_db_dev b.pgsql_db_dev
  && String.equal a.pgsql_user b.pgsql_user
  && String.equal a.pgsql_pass b.pgsql_pass
  && Int.equal a.pgsql_connection_pool b.pgsql_connection_pool
  && String.equal
       (Logs.level_to_string (Some a.log_level))
       (Logs.level_to_string (Some b.log_level))
;;

let pp_aux
    pp_h
    ppf
    { pgsql_host
    ; pgsql_port
    ; pgsql_db_dev
    ; pgsql_db_test = _
    ; pgsql_connection_pool
    ; pgsql_user
    ; pgsql_pass
    ; log_level
    }
  =
  Format.fprintf
    ppf
    "{pgsql = \"postgresql://%s:%a@%s:%d/%s\"; pool = %d log_level = %a}"
    pgsql_user
    pp_h
    pgsql_pass
    pgsql_host
    pgsql_port
    pgsql_db_dev
    pgsql_connection_pool
    Logs.pp_level
    log_level
;;

let pp = pp_aux (fun ppf _ -> Format.fprintf ppf "***")

let make_environment
    pgsql_host
    pgsql_port
    pgsql_db_dev
    pgsql_db_test
    pgsql_connection_pool
    pgsql_user
    pgsql_pass
    log_level
  =
  { pgsql_host
  ; pgsql_port
  ; pgsql_db_dev
  ; pgsql_db_test
  ; pgsql_connection_pool
  ; pgsql_user
  ; pgsql_pass
  ; log_level
  }
;;

let validate =
  let open Validate in
  let open Free in
  make_environment
  <$> required string "PGSQL_HOST"
  <*> required (int & bounded_to 1 65535) "PGSQL_PORT"
  <*> required string "PGSQL_DB_DEV"
  <*> required string "PGSQL_DB_TEST"
  <*> (optional int "PGSQL_CONNECTION_POOL" >? 20)
  <*> required string "PGSQL_USER"
  <*> required string "PGSQL_PASS"
  <*> (optional string_to_log "LOG_LEVEL" >? Logs.Info)
;;

let init () =
  Lwt.return @@ Validate.Free.run ~provider:"env" Sys.getenv_opt validate
;;
