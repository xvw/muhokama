(** Some useful helpers for dealing with controllers. *)

open Lib_common

(** Render a [Tyxml view] as a string of Html (to be served by [Dream.html]). *)
val from_tyxml : Tyxml.Html.doc -> string

(** Redirect to a given endpoint. *)
val redirect_to
  :  ?anchor:string
  -> ?status:[< Dream.redirection ]
  -> ?code:int
  -> ?headers:(string * string) list
  -> ( [ `GET ]
     , 'handler_function
     , Dream.request -> Dream.response Dream.promise )
     Lib_service.Endpoint.t
  -> 'handler_function

(** Handle [form] using a [formlet] (usually defined in [Model]. )*)
val handle_form
  :  ?csrf:bool
  -> Dream.request
  -> ((string * string) list -> 'a Try.t)
  -> 'a Try.t Lwt.t

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
  val fetch : Dream.request -> Models.Flash_info.t option

  (** [fallback request] will persist the flash messages for the next request. *)
  val fallback : Dream.request -> unit
end

module Auth : sig
  (** [set_user_id request user] set the connected user session. *)
  val set_current_user : Dream.request -> Models.User.t -> unit Try.t Lwt.t

  (** Resolves the current connected user.*)
  val get_connected_user_id : Dream.request -> string option
end

(** Process a text string into HTML using [OMD]. *)
val markdown_to_html : string -> string
