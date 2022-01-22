open Lib_common

type t

val equal : t -> t -> bool
val init : migrations_path:string -> t Try.t Effect.t
val to_list : t -> (int * Migration.t) list
