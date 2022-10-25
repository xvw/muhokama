(** Define a model for [Shared_link]. *)

open Lib_common

(** {1 Types} *)

(** A type that describe a shared link. *)
type t = private
  { id : string
  ; title : string
  ; url : string
  ; creation_date : Ptime.t
  ; user : User_model.t
  }

(** A formlet for creating a new shared link. *)
type creation_form

(** {1 Action} *)

(** Store a new shared link. *)
val create : creation_form -> User_model.t -> Lib_db.t -> unit Try.t Lwt.t

(** {1 Helpers} *)

(** Equality between links. *)
val equal : t -> t -> bool

(** Pretty-printers for links. *)
val pp : t Fmt.t

(** {1 Form validation} *)

(** Form validation for creating a new shared link. *)
val validate_creation
  :  ?title_field:string
  -> ?url_field:string
  -> (string * string) list
  -> creation_form Try.t
