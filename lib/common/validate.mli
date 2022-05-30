(** A biased version of [Validation] where the error type is set to be a value
    of type [Error.Set.t]. *)

(** {1 Type} *)

type 'a t = ('a, Error.t Preface.Nonempty_list.t) Preface.Validation.t

(** {1 Preface Implementation} *)

module Functor : Preface.Specs.FUNCTOR with type 'a t = 'a t
module Alt : Preface.Specs.ALT with type 'a t = 'a t

module Applicative :
  Preface.Specs.Traversable.API_OVER_APPLICATIVE with type 'a t = 'a t

module Monad : Preface.Specs.Traversable.API_OVER_MONAD with type 'a t = 'a t

(** {1 API} *)

val valid : 'a -> 'a t
val invalid : Error.t Preface.Nonempty_list.t -> 'a t
val error : Error.t -> 'a t
val pp : 'a Fmt.t -> 'a t Fmt.t
val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
val map : ('a -> 'b) -> 'a t -> 'b t
val apply : ('a -> 'b) t -> 'a t -> 'b t
val bind : ('a -> 'b t) -> 'a t -> 'b t

(** {1 Infix operators} *)

module Infix : sig
  type nonrec 'a t = 'a t

  include Preface.Specs.Alt.INFIX with type 'a t := 'a t
  include Preface.Specs.Applicative.INFIX with type 'a t := 'a t
  include Preface.Specs.Monad.INFIX with type 'a t := 'a t

  val ( & ) : ('a -> 'b t) -> ('b -> 'c t) -> 'a -> 'c t
end

(** {1 Syntax operators} *)

module Syntax : sig
  type nonrec 'a t = 'a t

  include Preface.Specs.Applicative.SYNTAX with type 'a t := 'a t
  include Preface.Specs.Monad.SYNTAX with type 'a t := 'a t
end

include module type of Infix with type 'a t := 'a t
include module type of Syntax with type 'a t := 'a t

(** {1 Predefined validators} *)

val from_predicate : ?message:string -> ('a -> bool) -> 'a -> 'a t
val greater_than : int -> int -> int t
val smaller_than : int -> int -> int t
val bounded_to : int -> int -> int -> int t
val not_empty : string -> string t
val not_blank : string -> string t
val is_email : string -> string t
val is_true : bool -> unit t
val is_false : bool -> unit t

(** {1 Free Validation} *)

type key = string
type value = string

module Free : sig
  type 'a validation := 'a t

  include Preface_specs.FREE_APPLICATIVE

  val run : ?name:string -> (key -> value option) -> 'a t -> 'a Try.t
  val optional : (value -> 'a validation) -> key -> 'a option t
  val required : (value -> 'a validation) -> key -> 'a t
  val or_ : 'a option t -> 'a -> 'a t
  val ( >? ) : 'a option t -> 'a -> 'a t
  val string : string -> string validation
  val int : string -> int validation
  val bool : string -> bool validation
end
