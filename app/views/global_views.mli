(** An empty page that just display an error.*)
val error
  :  ?flash_info:Models.Flash_info.t
  -> ?user:Models.User.t
  -> unit
  -> Tyxml.Html.doc
