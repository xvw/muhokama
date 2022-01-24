open Lib_common

type t

val equal : t -> t -> bool
val init : migrations_path:string -> t Try.t Effect.t
val current_state : t -> int
val to_list : t -> (int * Migration.t) list
