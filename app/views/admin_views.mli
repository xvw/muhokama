(** A view for listing moderable users. *)
val users
  :  ?flash_info:Models.Flash_info.t
  -> csrf_token:string
  -> ?user:Models.User.t
  -> active:Models.User.t list
  -> inactive:Models.User.t list
  -> unit
  -> Tyxml.Html.doc
