(** A set of services mainly for testing pages (which may disappear in
    production).*)

open Lib_service

(** A service that renders a page displaying Hello World. This page requires the
    user to be logged in. *)
val hello_world : (Dream.request, Dream.response) Service.t
