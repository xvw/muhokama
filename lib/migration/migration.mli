(** A migration is a structure that has an index, a label such that its file
    respects this naming scheme [index-label.yml] to which is associated a list
    of SQL queries to "mount the migration" and a list of SQL queries to return
    to the previous state. In addition, a migration is associated with a hash
    calculated according to the previous migration to ensure that a migration
    has not been modified over time. If this is the case, all migrations must be
    rollbacked and everything replayed. *)

open Lib_common
open Lib_crypto

type t = private
  { index : int
  ; label : string
  ; file : string
  ; up : string list
  ; down : string list
  ; previous_hash : Sha256.t
  }

(** Type for validating migration name scheme. *)
type file =
  | Valid_name_scheme of
      { index : int
      ; label : string
      ; file : string
      }
  | Invalid_name_scheme of { file : string }

(** [make index label file up down previous_hash] create a migration
    representation. *)
val make
  :  int
  -> string
  -> string
  -> string list
  -> string list
  -> Sha256.t
  -> t

(** [build label file previous_migration assoc] is like [make] but taking an
    assoc object. *)
val build : int -> string -> string -> Sha256.t -> Assoc.Jsonm.t -> t Try.t

(** [hash migration] hash the migration representation. *)
val hash : t -> Sha256.t

(** [is_valid_filename f] will check if the filename has the scheme
    [id-name.yml]. *)
val is_valid_filename : string -> file

(** Equality between migrations. It uses hash for comparison. *)
val equal : t -> t -> bool

(** Equality between migration files. *)
val equal_file : file -> file -> bool

(** Pretty-printer for migration. *)
val pp : t Fmt.t

(** Pretty-printer for migration file. *)
val pp_file : file Fmt.t
