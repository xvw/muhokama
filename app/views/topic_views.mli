(** Set of views related to topics. *)

(** A view for creating a new topic. *)
val create
  :  ?flash_info:Models.Flash_info.t
  -> csrf_token:string
  -> ?user:Models.User.t
  -> Models.Category.t Preface.Nonempty_list.t
  -> Tyxml.Html.doc

(** A view for listing topics. *)
val list
  :  ?flash_info:Models.Flash_info.t
  -> ?user:Models.User.t
  -> Models.Topic.Listable.t list
  -> Tyxml.Html.doc

(** A view for showing one topic. *)
val show
  :  ?flash_info:Models.Flash_info.t
  -> ?user:Models.User.t
  -> Models.Topic.Showable.t
  -> Tyxml.Html.doc
