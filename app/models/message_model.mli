(** Defines some model related to a message. *)

open Lib_common

(** {1 Types} *)

(** Describe a message. *)
type t = private
  { id : string
  ; user_name : string
  ; user_email : string
  ; creation_date : Ptime.t
  ; content : string
  }

(** {2 Form}

    The forms are models intended to validate the data before it is persisted in
    the database. They exist for any kind of action. A [Form] is the result of a
    form validation.*)

type creation_form

(** {1 Helpers} *)

(** Pretty-printer for [t]. *)
val pp : t Fmt.t

(** Equality between [t]. *)
val equal : t -> t -> bool

(** {1 Actions} *)

(** Return the number of stored messages. *)
val count : Lib_db.t -> int Try.t Lwt.t

(** Create a new message into a topic. *)
val create
  :  User_model.t
  -> string
  -> creation_form
  -> Lib_db.t
  -> string Try.t Lwt.t

(** Map a function over the message content. *)
val map_content : (string -> string) -> t -> t

(** Get a list of messages by topics ordered by creation date. *)
val get_by_topic_id : (t -> 'a) -> string -> Lib_db.t -> 'a list Try.t Lwt.t

(** {1 Form validation} *)

val validate_creation
  :  ?content_field:string
  -> (string * string) list
  -> creation_form Try.t
