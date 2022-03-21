(** Set of views related to users. *)

(** A view for registrating a new user. *)
val create
  :  ?flash_info:Model.Flash_info.t
  -> csrf_token:string
  -> unit
  -> Tyxml.Html.doc

(** A view for login an user. *)
val login
  :  ?flash_info:Model.Flash_info.t
  -> csrf_token:string
  -> unit
  -> Tyxml.Html.doc

(** A view for listing active users. *)
val list_active
  :  ?flash_info:Model.Flash_info.t
  -> ?user:Model.User.Saved.t
  -> Model.User.Saved.t list
  -> unit
  -> Tyxml.Html.doc

(** A view for listing moderable users. *)
val list_moderable
  :  ?flash_info:Model.Flash_info.t
  -> ?user:Model.User.Saved.t
  -> active:Model.User.Saved.t list
  -> inactive:Model.User.Saved.t list
  -> unit
  -> Tyxml.Html.doc
