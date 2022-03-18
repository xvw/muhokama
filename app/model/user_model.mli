(** Defines some model related to the users. For example, an user before being
    saved. Or a connected user.*)

open Lib_common

(** [State] represents the state of an user. *)
module State : sig
  type t =
    | Inactive (** When the user just be registered. *)
    | Member (** When the user was activated. *)
    | Moderator (** Status and power to be defined. *)
    | Admin (** Status and power to be defined. *)
    | Unknown of string
        (** When the status is not handle. (Migration purpose). *)

  val equal : t -> t -> bool
  val pp : t Fmt.t
  val to_string : t -> string
  val validate_state : string -> t Validate.t
  val try_state : string -> t Try.t
  val from_string : string -> t

  (** A comparison where [Unknown] < [Inactive] < [Member] < [Moderator] <
      [Admin]. *)
  val compare : t -> t -> int
end

(** An user before registration (so without ID and always inactive). *)
module For_registration : sig
  type t = private
    { user_name : string
    ; user_email : string
    ; user_password : Lib_crypto.Sha256.t
    }

  (** key that reference [user_name]. (That can be useful for generating
      formlet) *)
  val user_name_key : string

  (** key that reference [user_email]. (That can be useful for generating
      formlet) *)
  val user_email_key : string

  (** key that reference [user_password]. (That can be useful for generating
      formlet) *)
  val user_password_key : string

  (** key that reference [user_password] confirmation. (That can be useful for
      generating formlet) *)
  val confirm_user_password_key : string

  (** Produce a [t] using a Json representation. *)
  val from_yojson : Assoc.Yojson.t -> t Try.t

  (** Produce a [t] from an associative list (for example, urlencoded value from
      a post query).*)
  val from_assoc_list : (string * string) list -> t Try.t

  (** Save it in database*)
  val save : t -> Caqti_lwt.connection -> unit Try.t Lwt.t

  val pp : t Fmt.t
  val equal : t -> t -> bool
end

(** A model that describe a saved user. *)
module Saved : sig
  type t = private
    { user_id : string
    ; user_name : string
    ; user_email : string
    ; user_state : State.t
    }

  (** [count db] try to get the number of saved users. *)
  val count : Caqti_lwt.connection -> int Try.t Lwt.t

  (** [iter f db] apply [f] on each saved users. *)
  val iter : (t -> unit) -> Caqti_lwt.connection -> unit Try.t Lwt.t

  (** [change_state ~user_id new_state db] try to change the state of an user. *)
  val change_state
    :  user_id:string
    -> State.t
    -> Caqti_lwt.connection
    -> unit Try.t Lwt.t

  (** [activate ~user_id] activate an user. *)
  val activate : user_id:string -> Caqti_lwt.connection -> unit Try.t Lwt.t
end
