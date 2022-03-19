(** To be easily testable, the migration engine abstracts the execution of the
    effects. In this way, we can easily provide another program handler that
    simulates the execution of the migrations. This module describes the
    plumbing related to the use of user-defined effects. *)

open Lib_common

(** {1 Effect plumbing} *)

type _ effects =
  | Fetch_migrations : string -> string list Try.t effects
  | Read_migration : string -> Assoc.Jsonm.t Try.t effects
  | Info : string -> unit effects
  | Warning : string -> unit effects
  | Error : Error.t -> 'a effects

include Preface.Specs.FREER_MONAD with type 'a f = 'a effects (** @inline *)

module Traverse :
  Preface.Specs.TRAVERSABLE with type 'a t = 'a t and type 'a iter = 'a list

(** {1 Propagating effect} *)

val info : string -> unit t
val warning : string -> unit t
val error : Error.t -> 'a t
val get_migrations_files : string -> Migration.file list t
val read_migration_file_to_assoc : string -> string -> Assoc.Jsonm.t t

(** {1 Default interpreter}

    An interpreter that performs factual reading of migrations *)

val default_runner : 'a Try.t t -> 'a Try.t
