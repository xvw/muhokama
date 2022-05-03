open Lib_common

(** [State] represents the state of an user. *)

type t =
  | Inactive (** When the user just be registered. *)
  | Member (** When the user was activated. *)
  | Moderator (** Status and power to be defined. *)
  | Admin (** Status and power to be defined. *)
  | Unknown of string (** When the status is not handle. (Migration purpose). *)

val equal : t -> t -> bool
val pp : t Fmt.t
val to_string : t -> string
val validate_state : string -> t Validate.t
val try_state : string -> t Try.t
val from_string : string -> t
val is_active : t -> bool

(** A comparison where [Unknown] < [Inactive] < [Member] < [Moderator] <
    [Admin]. *)
val compare : t -> t -> int

(** {1 Filtering over State} *)

type filter

val all : filter
val active : filter
val moderable : filter
val admin : filter
val with_power : filter
val moderator : filter
val member : filter
val inactive : filter
val unknown : ?state:string -> unit -> filter
val pp_filter : ?prefix:string -> unit -> filter Fmt.t
