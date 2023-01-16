(** All shared-links-related services. *)

open Lib_service

(** Display the list of shared links and a form for submitting one. *)
val root : (Dream.request, Dream.response) Service.t

(** Store a shared-link. *)
val create : (Dream.request, Dream.response) Service.t
