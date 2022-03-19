(** A plan is just a list of migration to performs. Using the context gives us
    plan.*)

open Lib_crypto

type t =
  | Forward of (int * Migration.t) list
  | Backward of (int * Migration.t) list * (int * Sha256.t)
  | Standby

val equal : t -> t -> bool
val pp : t Fmt.t
