type t =
  { pgsql_host : string
  ; pgsql_port : int
  ; pgsql_db_dev : string
  ; pgsql_db_test : string
  ; pgsql_user : string
  ; pgsql_pass : string
  ; log_level : Logs.level
  }

let string_to_log log =
  let open Preface.Validate in
  match String.lowercase_ascii log with
  | "debug" -> valid Logs.Debug
  | "info" -> valid Logs.Info
  | "warning" -> valid Logs.Warning
  | "error" -> valid Logs.Error
  | "app" -> valid Logs.App
  | unknown -> Exn.(as_validation @@ Invalid_log_level unknown)
;;

let equal a b =
  String.equal a.pgsql_host b.pgsql_host
  && Int.equal a.pgsql_port b.pgsql_port
  && String.equal a.pgsql_db_test b.pgsql_db_test
  && String.equal a.pgsql_db_dev b.pgsql_db_dev
  && String.equal a.pgsql_user b.pgsql_user
  && String.equal a.pgsql_pass b.pgsql_pass
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
    ; pgsql_db_test
    ; pgsql_user
    ; pgsql_pass
    ; log_level
    }
  =
  let open Pp in
  record
    ppf
    [ field "pgsql_host" pgsql_host string
    ; field "pgsql_port" pgsql_port int
    ; field "pgsql_db_dev" pgsql_db_dev string
    ; field "pgsql_db_test" pgsql_db_test string
    ; field "pgsql_user" pgsql_user string
    ; field "pgsql_pass" pgsql_pass pp_h
    ; field "log_level" log_level Logs.pp_level
    ]
;;

let pp = pp_aux (fun ppf _ -> Format.fprintf ppf "***")

let make_environment
    pgsql_host
    pgsql_port
    pgsql_db_dev
    pgsql_db_test
    pgsql_user
    pgsql_pass
    log_level
  =
  { pgsql_host
  ; pgsql_port
  ; pgsql_db_dev
  ; pgsql_db_test
  ; pgsql_user
  ; pgsql_pass
  ; log_level
  }
;;

let validate =
  let open Provider in
  make_environment
  <$> (optional string "PGSQL_HOST" |? "localhost")
  <*> (optional (int & bounded 1 65535) "PGSQL_PORT" |? 5432)
  <*> (optional string "PGSQL_DB_DEV" |? "muhokama_dev")
  <*> (optional string "PGSQL_DB_TEST" |? "muhokama_test")
  <*> (optional string "PGSQL_USER" |? "muhokama")
  <*> (optional string "PGSQL_PASS" |? "muhokam")
  <*> (optional string_to_log "LOG_LEVEL" |? Logs.Debug)
;;

let init () =
  (match Provider.run Sys.getenv_opt validate with
  | Preface.Validation.Invalid x -> Exn.(as_try @@ List x)
  | Preface.Validation.Valid x -> Ok x)
  |> Lwt.return
;;

let connect_to_db ?(test = false) env =
  Db.connect
    ~max_size:20
    ~host:env.pgsql_host
    ~port:env.pgsql_port
    ~user:env.pgsql_user
    ~password:env.pgsql_pass
    ~database:(if test then env.pgsql_db_test else env.pgsql_db_dev)
;;
