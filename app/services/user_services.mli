(** All user-related services. *)

open Lib_service

(** Prompt a login page. *)
val login : (Dream.request, Dream.response) Service.t

(** Prompt a registration page.*)
val create : (Dream.request, Dream.response) Service.t

(** Process the user registration. *)
val save : (Dream.request, Dream.response) Service.t

(** Process the user authentication. *)
val auth : (Dream.request, Dream.response) Service.t

(** Process sign-out (logout). *)
val leave : (Dream.request, Dream.response) Service.t

(** Generate the page of all active users. *)
val list_active : (Dream.request, Dream.response) Service.t

(** Generate the preferences page. **)
val get_preferences : (Dream.request, Dream.response) Service.t

(** Process the update of the preferences. **)
val set_preferences : (Dream.request, Dream.response) Service.t

(** Process the update of the password. **)
val set_password : (Dream.request, Dream.response) Service.t
