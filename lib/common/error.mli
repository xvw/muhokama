(** Error enumeration *)

(** {1 Types and exceptions} *)

type t =
  | Invalid_field of
      { key : string
      ; errors : t Preface.Nonempty_list.t
      }
  | Invalid_provider of
      { provider : string
      ; errors : t Preface.Nonempty_list.t
      }
  | Invalid_projection of
      { given_value : string
      ; target : string
      }
  | Unexpected_repr of { expected_repr : string }
  | Missing_field of string
  | Invalid_predicate of string
  | With_message of string
  | Invalid_log_level of string
  | Database of string
  | Invalid_migration_successor of
      { expected_index : int
      ; given_index : int
      }
  | Migration_invalid_checksum of int
  | Migration_invalid_target of int
  | Migration_context_error of t
  | Unable_to_read_dir of string
  | Unable_to_read_file of string
  | Yaml of string
  | Unknown

exception From_error of t

(** {1 Error set} *)

module Set : sig
  type error := t

  include Preface.Specs.SEMIGROUP

  val equal : t -> t -> bool
  val pp : t Fmt.t
  val singleton : error -> t
  val from_nonempty_list : error Preface.Nonempty_list.t -> t
  val to_nonempty_list : t -> error Preface.Nonempty_list.t
end

(** {1 API} *)

val pp : t Fmt.t
val equal : t -> t -> bool
val to_exn : t -> exn
val to_try : t -> ('a, t) Preface.Result.t
val to_validate : t -> ('a, Set.t) Preface.Validation.t

val collapse_for_field
  :  string
  -> ('a, Set.t) Preface.Validation.t
  -> ('a, Set.t) Preface.Validation.t
