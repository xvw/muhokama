(** Helper for dealing with Database. *)

open Lib_common

type 'a connection =
  (Caqti_lwt.connection, ([> Caqti_error.connect ] as 'a)) Caqti_lwt.Pool.t

(** Build the [uri] locating the database. *)
val make_uri
  :  user:string
  -> password:string
  -> host:string
  -> port:int
  -> database:string
  -> Uri.t

(** Create a pool of connection for the database. *)
val connect
  :  max_size:int
  -> user:string
  -> password:string
  -> host:string
  -> port:int
  -> database:string
  -> [> Caqti_error.connect ] connection Try.t Lwt.t

val connect_with_env : Env.t -> [> Caqti_error.connect ] connection Try.t Lwt.t

(** Lift Caqti result into a [Preface.Try.t]. *)
val as_try : ('a, [< Caqti_error.t ]) result Lwt.t -> 'a Try.t Lwt.t

val use
  :  ([< Caqti_error.t ] as 'b) connection
  -> (Caqti_lwt.connection -> ('c, 'b) result Lwt.t)
  -> 'c Try.t Lwt.t
