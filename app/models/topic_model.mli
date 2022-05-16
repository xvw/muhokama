(** Defines some model related to a topic. *)

open Lib_common

(** {1 Types} *)

(** The main type that define a topic.*)
type t = private
  { id : string
  ; category : Category_model.t
  ; user : User_model.t
  ; creation_date : Ptime.t
  ; title : string
  ; content : string
  }

(** {2 Form}

    The forms are models intended to validate the data before it is persisted in
    the database. They exist for any kind of action. A [Form] is the result of a
    form validation.*)

(** A type that define the validation of a creation formlet. *)
type creation_form

(** {1 Helpers} *)

(** Pretty-printer for [t]. *)
val pp : t Fmt.t

(** Equality between [t]. *)
val equal : t -> t -> bool

(** {1 Actions} *)

(** Count the number of saved topics. *)
val count : Lib_db.t -> int Try.t Lwt.t

(** Create a new topic. *)
val create : User_model.t -> creation_form -> Lib_db.t -> string Try.t Lwt.t

(** Retreive a topic by ID. *)
val get_by_id : string -> Lib_db.t -> t Try.t Lwt.t

(** [list ?filter callback db] compute the list topics (filtered by [filter] on
    category, by default [filter] is set to [None]). *)
val list : ?filter:string -> (t -> 'a) -> Lib_db.t -> 'a list Try.t Lwt.t

(** {1 Form validation} *)

val validate_creation
  :  ?category_id_field:string
  -> ?title_field:string
  -> ?content_field:string
  -> (string * string) list
  -> creation_form Try.t
