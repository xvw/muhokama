(** Defines some model related to a message. *)

open Lib_common

(** {1 Types} *)

(** Describe a message. *)
type t = private
  { id : string
  ; user_id : string
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
type update_form

(** {1 Helpers} *)

(** Pretty-printer for [t]. *)
val pp : t Fmt.t

(** Equality between [t]. *)
val equal : t -> t -> bool

(** Make a [t] without committing it. *)
val make : id:string -> content:string -> User_model.t -> Ptime.t -> t

(** Message contained in [creation_form]. *)
val created_message : creation_form -> string

(** Message contained in [update_form]. *)
val updated_message : update_form -> string

(** Test if [creation_form] was posted in preview mode. *)
val is_created_preview : creation_form -> bool

(** Test if [creation_form] was posted in preview mode. *)
val is_updated_preview : update_form -> bool

(** {1 Actions} *)

(** Return the number of stored messages. *)
val count : Lib_db.t -> int Try.t Lwt.t

(** Create a new message into a topic. *)
val create
  :  User_model.t
  -> string
  -> creation_form
  -> Lib_db.t
  -> (string * Topic_model.Showable.t) Try.t Lwt.t

(** Update an existing message. *)
val update
  :  topic_id:string
  -> message_id:string
  -> update_form
  -> Lib_db.t
  -> unit Try.t Lwt.t

(** Archive a message of a topic. *)
val archive
  :  topic_id:string
  -> message_id:string
  -> Lib_db.t
  -> unit Try.t Lwt.t

(** Map a function over the message content. *)
val map_content : (string -> string) -> t -> t

(** Get a list of messages by topics ordered by creation date. *)
val get_by_topic_id : (t -> 'a) -> string -> Lib_db.t -> 'a list Try.t Lwt.t

val get_by_topic_and_message_id
  :  topic_id:string
  -> message_id:string
  -> Lib_db.t
  -> t option Try.t Lwt.t

(** {1 Form validation} *)

val validate_creation
  :  ?content_field:string
  -> (string * string) list
  -> creation_form Try.t

val validate_update
  :  ?content_field:string
  -> (string * string) list
  -> update_form Try.t
