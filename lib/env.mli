(** Environment variables. *)

(** {1 Types} *)

type t = private
  { pgsql_host : string
  ; pgsql_port : int
  ; pgsql_db_dev : string
  ; pgsql_db_test : string
  ; pgsql_user : string
  ; pgsql_pass : string
  ; log_level : Logs.level
  }

val equal : t -> t -> bool
val pp : t Pp.t

(** [init ()] will produce a promise that fetch the current environment.*)
val init : unit -> t Preface.Try.t Lwt.t

(** Connect to the database. *)
val connect_to_db
  :  ?test:bool
  -> t
  -> (Caqti_lwt.connection, [> Caqti_error.connect ]) Caqti_lwt.Pool.t
     Preface.Try.t
     Lwt.t
