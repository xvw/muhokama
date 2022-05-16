open Lib_service

(** Root of the web application *)
val root : (Dream.request, Dream.response) Service.t

(** An empty page that just display errors. *)
val error : (Dream.request, Dream.response) Service.t
