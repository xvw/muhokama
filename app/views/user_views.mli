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

(** A view for listing moderable users. *)
val list_moderable
  :  ?flash_info:Models.Flash_info.t
  -> csrf_token:string
  -> ?user:Models.User.t
  -> active:Models.User.t list
  -> inactive:Models.User.t list
  -> unit
  -> Tyxml.Html.doc
