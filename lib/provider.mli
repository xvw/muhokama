(** Provider is a Free Applicative Functor that allows to read and validate data
    from optional strings, validate them and project them into arbitrary
    structures. For example to read environment variables. *)

(** {1 Types} *)

(** Describes a validatable field (the type embeds a key and a validation
    function). *)
type 'a field

(** {1 Applicative API} *)

include Preface.Specs.FREE_APPLICATIVE with type 'a f := 'a field (** @inline *)

(** {1 Run Free Validation to Validation} *)

module Run :
  Preface.Specs.Free_applicative.TO_APPLICATIVE
    with type 'a t := 'a t
     and type 'a f := 'a field
     and type 'a applicative := 'a Preface.Validate.t

(** {1 Validation} *)

val run : (string -> string option) -> 'a t -> 'a Preface.Validate.t

(** {1 Field fetching} *)

val optional : (string -> 'a Preface.Validate.t) -> string -> 'a option t
val required : (string -> 'a Preface.Validate.t) -> string -> 'a t
val ( |? ) : 'a option t -> 'a -> 'a t

(** {1 Validator} *)

(** Sequential composition of validator. *)
val ( & )
  :  ('a -> 'b Preface.Validate.t)
  -> ('b -> 'c Preface.Validate.t)
  -> 'a
  -> 'c Preface.Validate.t

val int : string -> int Preface.Validate.t
val greater_than : int -> int -> int Preface.Validate.t
val smaller_than : int -> int -> int Preface.Validate.t

(** [bounded min max] is [greater_than (min - 1) & smaller_than (max + 1)]. *)
val bounded : int -> int -> int -> int Preface.Validate.t

val string : string -> string Preface.Validate.t
val not_empty : string -> string Preface.Validate.t
val not_blank : string -> string Preface.Validate.t
