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
    ; category_id : string
    ; category_name : string
    ; user_id : string
    ; user_name : string
    ; user_email : string
    ; creation_date : Ptime.t
    ; title : string
    ; content : string
    }

  val make
    :  id:string
    -> category_id:string
    -> category_name:string
    -> user_id:string
    -> user_name:string
    -> user_email:string
    -> creation_date:Ptime.t
    -> title:string
    -> content:string
    -> t

  val pp : t Fmt.t
  val equal : t -> t -> bool
  val map_content : (string -> string) -> t -> t
end

(** {2 Form}

    The forms are models intended to validate the data before it is persisted in
    the database. They exist for any kind of action. A [Form] is the result of a
    form validation.*)

(** A type that defines the validation of a creation formlet. *)
type creation_form

(** A type that defines the validation of an update formlet. *)
type update_form

(** A type that helps checking a preview, where the title and category are
    optional. *)
type preview_form

(** Extract the title and the content of a creation formlet. *)
val extract_form : creation_form -> string * string

(** Extract the title and the content of an edit formlet. *)
val updated_form : update_form -> string * string

(** Extract the category id of a creation formlet. *)
val created_category : creation_form -> string

(** Extract the category id of a edit formlet. *)
val updated_category : update_form -> string

(** Test if a form was posted in preview mode. *)
val is_preview : preview_form -> bool

(** Extract the title and content of a preview formlet. The title is optional
    for a preview formlet. *)
val preview_form : preview_form -> string option * string

(** Extract the category id of a preview formlet. *)
val preview_category : preview_form -> string option

(** {1 Actions} *)

(** Count the number of saved topics. *)
val count : Lib_db.t -> int Try.t Lwt.t

(** Count the number of saved topics grouped by category. *)
val count_by_categories : Lib_db.t -> (string * string * int) list Try.t Lwt.t

(** Create a new topic. *)
val create : User_model.t -> creation_form -> Lib_db.t -> string Try.t Lwt.t

(** Update a created topic. *)
val update : string -> update_form -> Lib_db.t -> unit Try.t Lwt.t

(** Retreive a topic by ID. *)
val get_by_id : string -> Lib_db.t -> Showable.t Try.t Lwt.t

(** List all topics from an author by his ID **)
val list_by_author
  :  string
  -> (Listable.t -> 'a)
  -> Lib_db.t
  -> 'a list Try.t Lwt.t

(** List all topics. *)
val list_all : (Listable.t -> 'a) -> Lib_db.t -> 'a list Try.t Lwt.t

(** Archive a topic. *)
val archive : string -> Lib_db.t -> unit Try.t Lwt.t

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

val validate_update
  :  ?category_id_field:string
  -> ?title_field:string
  -> ?content_field:string
  -> (string * string) list
  -> update_form Try.t

val validate_preview
  :  ?category_id_field:string
  -> ?title_field:string
  -> ?content_field:string
  -> ?preview_field:string
  -> (string * string) list
  -> preview_form Try.t
