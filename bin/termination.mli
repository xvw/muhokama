open Lib_common

val exits : Cmdliner.Cmd.Exit.info list
val handle : 'a Try.t Lwt.t -> 'b
