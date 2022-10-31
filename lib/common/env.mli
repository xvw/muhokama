type t = private
  { pgsql_host : string
  ; pgsql_port : int
  ; pgsql_db : string
  ; pgsql_user : string
  ; pgsql_pass : string
  ; pgsql_connection_pool : int
  ; log_level : Logs.level
  ; notification_hook : string option
  }

val equal : t -> t -> bool
val pp : t Fmt.t
val init : unit -> t Try.t Lwt.t
