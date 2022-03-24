open Lib_common

type t = Caqti_lwt.connection

module type T = Caqti_lwt.CONNECTION

val try_ : ('a, Caqti_error.t) result Lwt.t -> 'a Try.t Lwt.t
val make_uri : Env.t -> Uri.t

val connect
  :  Env.t
  -> (Caqti_lwt.connection, [> Caqti_error.connect ]) Caqti_lwt.Pool.t Try.t
     Lwt.t

val use
  :  (Caqti_lwt.connection, Caqti_error.t) Caqti_lwt.Pool.t
  -> (Caqti_lwt.connection -> 'a Try.t Lwt.t)
  -> 'a Try.t Lwt.t
