open Lib_common

type _ effects =
  | Fetch_migrations : { migrations_path : string } -> string list Try.t effects
  | Read_migration : { filepath : string } -> Assoc.Jsonm.t Try.t effects
  | Info : string -> unit effects
  | Warning : string -> unit effects
  | Error : Error.t -> 'a effects

module Freer : sig
  include Preface.Specs.FREER_MONAD with type 'a f = 'a effects

  val fetch_migrations : migrations_path:string -> string list Try.t t

  val read_migration
    :  migrations_path:string
    -> filepath:string
    -> Assoc.Jsonm.t Try.t t

  val warning : string -> unit t
  val info : string -> unit t
  val error : Error.t -> 'a t
end

module Traverse :
  Preface.Specs.TRAVERSABLE
    with type 'a t = 'a Freer.t
     and type 'a iter = 'a list

include module type of Freer

val get_migrations_files : migrations_path:string -> string list t
