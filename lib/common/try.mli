(** A biased version of [Result] where the error type is set to be a value of
    type [Error.t]. *)

(** {1 Type} *)

type 'a t = ('a, Error.t) result

(** {1 Preface Implementation} *)

module Functor : Preface.Specs.FUNCTOR with type 'a t = 'a t

module Applicative :
  Preface.Specs.Traversable.API_OVER_APPLICATIVE with type 'a t = 'a t

module Monad : Preface.Specs.Traversable.API_OVER_MONAD with type 'a t = 'a t

(** {1 API} *)

val ok : 'a -> 'a t
val error : Error.t -> 'a t
val pp : 'a Fmt.t -> 'a t Fmt.t
val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
val map : ('a -> 'b) -> 'a t -> 'b t
val apply : ('a -> 'b) t -> 'a t -> 'b t
val bind : ('a -> 'b t) -> 'a t -> 'b t

val form
  :  [< `Ok of (string * string) list | (string * string) list Error.Form.raw ]
  -> (string * string) list t

(** {1 Infix operators} *)

module Infix : sig
  type nonrec 'a t = 'a t

  include Preface.Specs.Applicative.INFIX with type 'a t := 'a t
  include Preface.Specs.Monad.INFIX with type 'a t := 'a t
end

(** {1 Syntax operators} *)

module Syntax : sig
  type nonrec 'a t = 'a t

  include Preface.Specs.Applicative.SYNTAX with type 'a t := 'a t
  include Preface.Specs.Monad.SYNTAX with type 'a t := 'a t
end

include module type of Infix with type 'a t := 'a t
include module type of Syntax with type 'a t := 'a t
