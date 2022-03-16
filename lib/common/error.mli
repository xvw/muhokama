module IO : sig
  type t =
    | Unreadable_dir of { dirpath : string }
    | Unreadable_file of { filepath : string }
    | Invalid_loglevel of string

  val equal : t -> t -> bool
  val pp : t Fmt.t
end

module Migration : sig
  type t =
    | Invalid_successor of
        { expected_index : int
        ; given_index : int
        }
    | Invalid_target of { given_target : int }
    | Invalid_state of { current_state : int }
    | Invalid_checksum of { given_index : int }

  val equal : t -> t -> bool
  val pp : t Fmt.t
end

module Validable : sig
  type t =
    | Unconvertible_string of
        { given_value : string
        ; target_type : string
        }
    | Invalid_predicate of { with_message : string }
    | Is_smaller_than of
        { given_value : int
        ; min_bound : int
        }
    | Is_greater_than of
        { given_value : int
        ; max_bound : int
        }
    | Is_empty
    | Is_blank
    | Unexpected_representation of { expected_representation : string }

  val equal : t -> t -> bool
  val pp : t Fmt.t
end

module Field : sig
  type 'a t =
    | Missing of { name : string }
    | Invalid of
        { name : string
        ; errors : 'a Preface.Nonempty_list.t
        }

  val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
  val pp : 'a Fmt.t -> 'a t Fmt.t
end

module User : sig
  type t =
    | Email_already_taken of string
    | Username_already_taken of string
    | Identity_already_taken of
        { username : string
        ; email : string
        }
    | Invalid_state of string

  val equal : t -> t -> bool
  val pp : t Fmt.t
end

module Form : sig
  type t =
    | Expired of (string * string) list * float
    | Wrong_session of (string * string) list
    | Invalid_token of (string * string) list
    | Missing_token of (string * string) list
    | Many_tokens of (string * string) list
    | Wrong_content_type

  val equal : t -> t -> bool
  val pp : t Fmt.t
end

type t =
  | Migration of Migration.t
  | IO of IO.t
  | Validation of Validable.t
  | Database of string
  | Field of t Field.t
  | User of User.t
  | Form of Form.t
  | Yaml of string
  | Invalid_object of
      { name : string
      ; errors : t Preface.Nonempty_list.t
      }

val equal : t -> t -> bool
val pp : t Fmt.t
val yaml : string -> t
val database : string -> t
val migration_invalid_successor : expected_index:int -> given_index:int -> t
val migration_invalid_target : given_target:int -> t
val migration_invalid_state : current_state:int -> t
val migration_invalid_checksum : given_index:int -> t
val io_unreadable_dir : dirpath:string -> t
val io_unreadable_file : filepath:string -> t
val io_invalid_loglevel : string -> t

val form_error
  :  [ `Expired of (string * string) list * float
     | `Wrong_session of (string * string) list
     | `Invalid_token of (string * string) list
     | `Missing_token of (string * string) list
     | `Many_tokens of (string * string) list
     | `Wrong_content_type
     ]
  -> t

val validation_unconvertible_string
  :  given_value:string
  -> target_type:string
  -> t

val validation_invalid_predicate : with_message:string -> t
val validation_is_smaller_than : given_value:int -> min_bound:int -> t
val validation_is_greater_than : given_value:int -> max_bound:int -> t
val validation_is_blank : t
val validation_is_empty : t
val validation_unexpected_representation : expected_representation:string -> t
val field_missing : name:string -> t
val field_invalid : name:string -> errors:t Preface.Nonempty_list.t -> t
val user_email_already_taken : string -> t
val user_name_already_taken : string -> t
val user_already_taken : username:string -> email:string -> t
val user_invalid_state : string -> t
val invalid_object : name:string -> errors:t Preface.Nonempty_list.t -> t
val to_try : t -> ('a, t) Result.t
val to_validate : t -> ('a, t Preface.Nonempty_list.t) Preface.Validation.t

val collapse_for_field
  :  string
  -> ('a, t Preface.Nonempty_list.t) Preface.Validation.t
  -> ('a, t Preface.Nonempty_list.t) Preface.Validation.t

type error_tree =
  | Leaf of
      { label : string
      ; message : string option
      }
  | Node of
      { label : string
      ; tree : error_tree list
      }

val normalize : t -> error_tree
