(** Some useful helpers for dealing with controllers. *)

open Lib_common

(** Render a [Tyxml view] as a string of Html (to be served by [Dream.html]). *)
val from_tyxml : Tyxml.Html.doc -> string

(** Handle [form] using a [formlet] (usually defined in [Model]. )*)
val handle_form
  :  ?csrf:bool
  -> Dream.request
  -> ((string * string) list -> 'a Try.t)
  -> 'a Try.t Lwt.t
