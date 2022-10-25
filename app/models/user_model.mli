(** Defines some model related to an user. *)

open Lib_common

(** {1 Define an [user state]} *)

module State = User_state

(** {1 Types} *)

(** The main type that define an user.*)
type t = private
  { id : string
  ; name : string
  ; email : string
  ; state : State.t
  }

(** {2 Form}

    The forms are models intended to validate the data before it is persisted in
    the database. They exist for any kind of action, for example for login, for
    registering a new user or for changing the status. A [Form] is the result of
    a form validation.*)

(** A type that define the validation of a registration formlet.*)
type registration_form

(** A type that define the validation of a connection formlet.*)
type connection_form

(** A type that define the validation of a preference update formlet **)
type update_preference_form

(** A type that define the validation of a password update formlet **)
type update_password_form

(** A type that define the validation of an user state change formlet *)
type state_change_form

(** {1 Helpers} *)

(** [is_active user] returns true if an user is active. *)
val is_active : t -> bool

(** [can_moderate user] return true if an user can moderate. *)
val can_moderate : t -> bool

(** [can_edit user ~owner_id:string] return true if the user is, at least, a
    moderator, or if it has the same if of owner_id. *)
val can_edit : t -> owner_id:string -> bool

(** Pretty-printer for [User.t]. *)
val pp : t Fmt.t

(** Equality between [User.t]. *)
val equal : t -> t -> bool

(** {1 Actions} *)

(** Register an user from a [registration_form]. *)
val register : registration_form -> Lib_db.t -> unit Try.t Lwt.t

(** Update the preferences. **)
val update_preferences
  :  t
  -> update_preference_form
  -> Lib_db.t
  -> unit Try.t Lwt.t

(** Update the password. **)
val update_password : t -> update_password_form -> Lib_db.t -> unit Try.t Lwt.t

(** Get an user from a [connection_form]. *)
val get_for_connection : connection_form -> Lib_db.t -> t Try.t Lwt.t

(** Update an user state from a [state_change_form]. *)
val update_state : state_change_form -> Lib_db.t -> unit Try.t Lwt.t

(** Returns the number of stored users. *)
val count : ?filter:State.filter -> Lib_db.t -> int Try.t Lwt.t

(** [list ?filter ?like callback db] compute the list users (filtered by
    [filter], by default [filter] is set to [all]) using a like query over
    [user_name] or [user_email] (for filtering). *)
val list
  :  ?filter:State.filter
  -> ?like:string
  -> (t -> 'a)
  -> Lib_db.t
  -> 'a list Try.t Lwt.t

(** [iter f db] apply [f] on each saved users. *)
val iter : (t -> unit) -> Lib_db.t -> unit Try.t Lwt.t

(** [change_state ~user_id new_state db] try to change the state of an user. *)
val change_state : user_id:string -> State.t -> Lib_db.t -> unit Try.t Lwt.t

(** [activate user_id] try to activate an user. *)
val activate : string -> Lib_db.t -> unit Try.t Lwt.t

(** [get_by_email email] try to fetch an user by his email. *)
val get_by_email : string -> Lib_db.t -> t Try.t Lwt.t

(** [get_by_id id] try to fetch an user by his id. *)
val get_by_id : string -> Lib_db.t -> t Try.t Lwt.t

(** [get_by_email_and_password email pwd] try to fetch an user by his email and
    password. *)
val get_by_email_and_password : string -> string -> Lib_db.t -> t Try.t Lwt.t

(** {1 Form validation} *)

(** Try to validate POST params for an user's registration. *)
val validate_registration
  :  ?name_field:string
  -> ?email_field:string
  -> ?password_field:string
  -> ?confirm_password_field:string
  -> (string * string) list
  -> registration_form Try.t

(** Try to validate POST params for an user's connection. *)
val validate_connection
  :  ?email_field:string
  -> ?password_field:string
  -> (string * string) list
  -> connection_form Try.t

(** Try to validate POST params for an user who update his infos. *)
val validate_preferences_update
  :  ?name_field:string
  -> ?email_field:string
  -> t
  -> (string * string) list
  -> update_preference_form Lib_common.Try.t

(** Try to validate POST params for an user who update his password. *)
val validate_password_update
  :  ?password_field:string
  -> ?confirm_password_field:string
  -> t
  -> (string * string) list
  -> update_password_form Lib_common.Try.t

(** Try to validate POST params for an user's state change. *)
val validate_state_change
  :  ?id_field:string
  -> ?action_field:string
  -> (string * string) list
  -> state_change_form Try.t
