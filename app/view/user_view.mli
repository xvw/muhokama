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

(** A view for listing users. *)
val list
  :  ?flash_info:Model.Flash_info.t
  -> ?user:Model.User.Saved.t
  -> Model.User.Saved.t list
  -> unit
  -> Tyxml.Html.doc
