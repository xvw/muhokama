open Lib_common

val exits : Cmdliner.Term.exit_info list
val handle : 'a Try.t Lwt.t -> 'b
