open Lib_common

val reset : Caqti_error.t Lib_db.connection -> 'a -> unit Try.t Lwt.t

val migrate
  :  Caqti_error.t Lib_db.connection
  -> string
  -> int option
  -> unit Try.t Lwt.t
