(** Defines some model related to a topic. *)

open Lib_common

(** {1 Types} *)

(** A topic that can be listable. *)
module Listable : sig
  type t = private
    { id : string
    ; category_name : string
    ; user_name : string
    ; user_email : string
    ; title : string
    ; responses : int
    }

  val pp : t Fmt.t
  val equal : t -> t -> bool
end

(** A topic that can be showable. *)
module Showable : sig
  type t = private
    { id : string
    ; category_name : string
    ; user_name : string
    ; user_email : string
    ; creation_date : Ptime.t
    ; title : string
    ; content : string
    }

  val pp : t Fmt.t
  val equal : t -> t -> bool
end

(** {2 Form}

    The forms are models intended to validate the data before it is persisted in
    the database. They exist for any kind of action. A [Form] is the result of a
    form validation.*)

(** A type that define the validation of a creation formlet. *)
type creation_form

(** {1 Actions} *)

(** Count the number of saved topics. *)
val count : Lib_db.t -> int Try.t Lwt.t

(** Count the number of saved topics grouped by category. *)
val count_by_categories : Lib_db.t -> (string * string * int) list Try.t Lwt.t

(** Create a new topic. *)
val create : User_model.t -> creation_form -> Lib_db.t -> string Try.t Lwt.t

(** Retreive a topic by ID. *)
val get_by_id : string -> Lib_db.t -> Showable.t Try.t Lwt.t

(** List all topics. *)
val list_all : (Listable.t -> 'a) -> Lib_db.t -> 'a list Try.t Lwt.t

(** List all topics by category. *)
val list_by_category
  :  string
  -> (Listable.t -> 'a)
  -> Lib_db.t
  -> 'a list Try.t Lwt.t

(** {1 Form validation} *)

val validate_creation
  :  ?category_id_field:string
  -> ?title_field:string
  -> ?content_field:string
  -> (string * string) list
  -> creation_form Try.t
