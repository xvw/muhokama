(** Some helpers for dealing with IO. *)

(** {1 Types} *)

type filename = string
type dirname = string
type dirpath = string
type filepath = string

(** {1 API} *)

val read_dir : dirpath -> filename list Try.t
val read_file : filepath -> string Try.t
