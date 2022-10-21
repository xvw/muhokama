(** Set of views related to users. *)

(** A view for registrating a new user. *)
val create
  :  ?flash_info:Models.Flash_info.t
  -> csrf_token:string
  -> unit
  -> Tyxml.Html.doc

(** A view for login an user. *)
val login
  :  ?flash_info:Models.Flash_info.t
  -> csrf_token:string
  -> unit
  -> Tyxml.Html.doc

(** A view for listing active users. *)
val list_active
  :  ?flash_info:Models.Flash_info.t
  -> ?user:Models.User.t
  -> Models.User.t list
  -> unit
  -> Tyxml.Html.doc

(** A view for modifying user infos**)
val get_preference :
  ?flash_info:Models.Flash_info.t ->
  csrf_token:string ->
  user:Models.User.t -> unit -> [> Html_types.html ] Tyxml_html.elt
