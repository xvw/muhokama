(** Describes the range of errors that can occur and provides helpers. *)

(** {1 Types} *)

(** [Exn.t] is an alias on [exn]. *)
type t = exn

(** {1 Exceptions}

    All declared exceptions. *)

(** An unknown exception.*)
exception Unknown

(** An unknown exception with a message attached. *)
exception Unknown_with_message of string

(** An error list (mainly to project Validation in Try).*)
exception List of t list

(** Error propagated when a required field is missing. *)
exception Required_field of string

(** Error propagated when a field is invalid. *)
exception
  Invalid_field of
    { key : string
    ; errors : t Preface.Nonempty_list.t
    }

(** Error propagated when a value cannot be projected into a type. *)
exception
  Unexpected_value of
    { expected_type : string
    ; given_value : string
    }

(** Error propagated when an integer is too large. *)
exception
  Int_too_large of
    { given_value : int
    ; max_bound : int
    }

(** Error propagated when an integer is too small. *)
exception
  Int_too_small of
    { given_value : int
    ; min_bound : int
    }

(** Propagated when a string is empty.*)
exception String_is_empty

(** Propagated when a string is blank.*)
exception String_is_blank of string

(** {1 Helpers} *)

val equal : t -> t -> bool
val pp : t Pp.t
val pp_desc : t Pp.t
val as_try : t -> 'a Preface.Try.t
val as_validation : t -> 'a Preface.Validate.t
