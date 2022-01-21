open Lib_common
open Lib_crypto

type t

val make
  :  int
  -> string
  -> string
  -> string list
  -> string list
  -> Sha256.t option
  -> t

val hash : t -> Sha256.t

(** [is_valid_filename f] will check if the filename has the scheme
    [id-name.yml] and returns the id, the name and the filename wrapped in an
    option.*)
val is_valid_filename : string -> (int * string * string) option

val build
  :  int
  -> string
  -> string
  -> Sha256.t option
  -> Assoc.Jsonm.t
  -> t Try.t
