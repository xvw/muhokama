(** A context is a map that make an explicit relation between an index and a
    migration representation. Acting on a Context is pure but init-it involves
    some effects. *)

open Lib_common

type t

(** [init migration_dir] perform an effect that computes the migration context
    for a given directory.

    The logic of initializing a migration context is pretty simple.

    - List all files presents in the given [migration] dir
    - Validate their name scheme using {!val:Migration.is_valid_filename}
    - Sorting the list pushing all invalid name scheme at the end. *)
val init : string -> t Try.t Effect.t

(** [plan ~current ?target ctx] Computes the plan needed to go from [current] to
    [target]. If no target is given, the goal is to reach the latest migration. *)
val plan : current:int -> ?target:int -> t -> Plan.t Try.t

(** Equality between contexts. *)
val equal : t -> t -> bool

(** Transform a context to an assoc list. *)
val to_list : t -> (int * Migration.t) list

(** [valid_checksum index hash ctx] ensures that [hash] is the same of the hash
    in [ctx] for a given [index]. This function allow ensuring that migrations
    file was not modified. *)
val valid_checksum : int -> string -> t -> unit Try.t
