(** Defines some model related to a category. *)

(** {1 Types} *)

open Lib_common

(** The main type that define a category.*)
type t = private
  { id : string
  ; name : string
  ; description : string
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

(** Count the number of saved categories. *)
val count : Lib_db.t -> int Try.t Lwt.t

(** List all of categories (sorted by name). *)
val list : (t -> 'a) -> Lib_db.t -> 'a list Try.t Lwt.t

(** Find a category by his name. *)
val get_by_name : string -> Lib_db.t -> t Try.t Lwt.t

(** Find a category by his id. *)
val get_by_id : string -> Lib_db.t -> t Try.t Lwt.t

(** Create a new category. *)
val create : creation_form -> Lib_db.t -> unit Try.t Lwt.t

(** {1 Form validation} *)

(** Try to validate POST params for a category creation. *)
val validate_creation
  :  ?name_field:string
  -> ?description_field:string
  -> (string * string) list
  -> creation_form Try.t
