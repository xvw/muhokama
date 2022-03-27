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

(** The controller for listing active users. *)
val list_active : Model.User.t -> Dream.handler

(** The controller for listing moderable users. *)
val list_moderable : Model.User.t -> Dream.handler

(** The controller for patching the state of an user. *)
val state_change : Model.User.t -> Dream.handler

(** {1 Middleware} *)

val provide_user : (Model.User.t -> Dream.handler) -> Dream.handler
val provide_moderator : (Model.User.t -> Dream.handler) -> Dream.handler
val provide_administrator : (Model.User.t -> Dream.handler) -> Dream.handler
val is_authenticated : Dream.middleware
val is_not_authenticated : Dream.middleware
