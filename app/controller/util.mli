(** Some useful helpers for dealing with controllers. *)

(** Render a [Tyxml view] as a string of Html (to be served by [Dream.html]). *)
val from_tyxml : Tyxml.Html.doc -> string

(** Inject and retreives flash infos. *)
module Flash_info : sig
  (** [action request message] will store the message as an [Action] into the
      [request] handler. *)
  val action : Dream.request -> string -> unit

  (** [info request message] will store the message as an [Info] into the
      [request] handler. *)
  val info : Dream.request -> string -> unit

  (** [alert request message] will store the message as an [Alert] into the
      [request] handler. *)
  val alert : Dream.request -> string -> unit

  (** [action request error] will store the error as an [Error_tree] into the
      [request] handler. *)
  val error_tree : Dream.request -> Lib_common.Error.t -> unit

  (** [nothing request] clear (or fill with nothing). *)
  val nothing : Dream.request -> unit

  (** [fetch request] will fetch the current flash info from the [request]
      handler. *)
  val fetch : Dream.request -> Model.Flash_info.t option
end
