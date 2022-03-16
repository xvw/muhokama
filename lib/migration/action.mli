open Lib_common

val reset : Caqti_lwt.connection -> 'a -> unit Try.t Lwt.t
val migrate : Caqti_lwt.connection -> string -> int option -> unit Try.t Lwt.t
