(** All topic-related services. *)

open Lib_service

(** Prompt the list of topics. *)
val list : (Dream.request, Dream.response) Service.t

(** Prompte a topic creation page. *)
val create : (Dream.request, Dream.response) Service.t

(** Save a new topic. *)
val save : (Dream.request, Dream.response) Service.t

(** Show one topic. *)
val show : (Dream.request, Dream.response) Service.t
