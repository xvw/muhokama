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

val make
  :  int
  -> string
  -> string
  -> string list
  -> string list
  -> Sha256.t
  -> t

val hash : t -> Sha256.t
val equal : t -> t -> bool
val pp : t Fmt.t

(** [is_valid_filename f] will check if the filename has the scheme
    [id-name.yml] and returns the id, the name and the filename wrapped in an
    option.*)
val is_valid_filename : string -> (int * string * string) option

val build : int -> string -> string -> Sha256.t -> Assoc.Jsonm.t -> t Try.t
