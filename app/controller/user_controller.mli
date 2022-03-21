(** A set of controllers related to the user management. *)

(** The controller for rendering the registration form. *)
val create : Dream.handler

(** The controller for rendering the login form. *)
val login : Dream.handler

(** The controller for processing (and saving) a new user. *)
val save : Dream.handler

(** The controller for authenticate an activated user.*)
val auth : Dream.handler

(** The controller for disconnection.*)
val leave : Dream.handler

(** The controller for listing users. *)
val list : Model.User.Saved.t -> Dream.handler

(** {1 Middleware} *)

val provide_user
  :  (Model.User.Saved.t -> Dream.request -> Dream.response Dream.promise)
  -> Dream.request
  -> Dream.response Dream.promise

val is_authenticated : Dream.middleware
val is_not_authenticated : Dream.middleware
