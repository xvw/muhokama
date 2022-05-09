(** All admin-related services. *)

open Lib_service

(** Currently, just redirect to [user]. *)
val root : (Dream.request, Dream.response) Service.t

(** Provide the user moderation page. *)
val user : (Dream.request, Dream.response) Service.t

(** Perform the action of changing state of an user.*)
val user_state_change : (Dream.request, Dream.response) Service.t
