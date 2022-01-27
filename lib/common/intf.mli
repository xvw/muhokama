(** Generalized interfaces *)

(** {1 Assoc}

    The association interfaces allow to validate data structured in key-values
    more or less generically and the implementation is freely inspired by the
    technique presented in {{:https://xhtmlboi.github.io/articles/yocaml.html}
    this article}. *)

type ('visited, 'input, 'output) visitor =
  ('input -> 'output) -> (unit -> 'output) -> 'visited -> 'output

(** By implementing this interface, generic validation strategies can be
    defined. *)
module type AS_ASSOC = sig
  type t

  val as_object : (t, (string * t) list, 'a) visitor
  val as_list : (t, t list, 'a) visitor
  val as_atom : (t, string, 'a) visitor
  val as_string : (t, string, 'a) visitor
  val as_bool : (t, bool, 'a) visitor
  val as_int : (t, int, 'a) visitor
  val as_float : (t, float, 'a) visitor
  val as_null : (t, unit, 'a) visitor
end

(** This interface describes the complete API of an association structure that
    can be validated. *)
module type VALIDABLE_ASSOC = sig
  type t

  val run : ?provider:string -> 'a Validate.t -> 'a Try.t

  (** {1 Simple validator}

      Who just makes sure that the element of the associative construction
      respects the requested form. *)

  val object_ : t -> (string * t) list Validate.t
  val list : t -> t list Validate.t
  val atom : t -> string Validate.t
  val string : t -> string Validate.t
  val bool : t -> bool Validate.t
  val int : t -> int Validate.t
  val float : t -> float Validate.t
  val null : t -> unit Validate.t

  (** {1 Composite Validators}

      Ensures that the element in the associative structure respects the
      requested form and then applies an additional validator to it. *)

  val object_and : ((string * t) list -> 'a Validate.t) -> t -> 'a Validate.t
  val list_and : (t list -> 'a Validate.t) -> t -> 'a Validate.t
  val list_of : (t -> 'a Validate.t) -> t -> 'a list Validate.t
  val atom_and : (string -> 'a Validate.t) -> t -> 'a Validate.t
  val string_and : (string -> 'a Validate.t) -> t -> 'a Validate.t
  val bool_and : (bool -> 'a Validate.t) -> t -> 'a Validate.t
  val int_and : (int -> 'a Validate.t) -> t -> 'a Validate.t
  val float_and : (float -> 'a Validate.t) -> t -> 'a Validate.t

  (** {1 Queries over fields} *)

  val optional
    :  (t -> 'a Validate.t)
    -> string
    -> (string * t) list
    -> 'a option Validate.t

  val required
    :  (t -> 'a Validate.t)
    -> string
    -> (string * t) list
    -> 'a Validate.t

  val ensure_equality : string -> string -> (string * t) list -> unit Validate.t
  val or_ : 'a option Validate.t -> 'a -> 'a Validate.t
  val ( >? ) : 'a option Validate.t -> 'a -> 'a Validate.t
  val equal : t -> t -> bool
end
