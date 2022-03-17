(** A set of controllers related to the user management. *)

(** The controller for rendering the registration form. *)
val create : Dream.request -> Dream.response Dream.promise

(** The controller for processing (and saving) a new user. *)
val save : Dream.request -> Dream.response Dream.promise
