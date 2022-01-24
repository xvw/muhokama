open Lib_common

type t

type step =
  | Up of (int * Migration.t) list
  | Down of (int * Migration.t) list * (int * Lib_crypto.Sha256.t)
  | Nothing

val equal : t -> t -> bool
val init : migrations_path:string -> t Try.t Effect.t
val current_state : t -> int * string
val get_migrations : current:int -> ?target:int -> t -> step Try.t
val to_list : t -> (int * Migration.t) list
val check_hash : t -> int -> string -> unit Try.t
