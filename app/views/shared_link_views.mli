(** The root of Shared Links Page !**)
val root
  :  ?flash_info:Models.Flash_info.t
  -> csrf_token:string
  -> user:Models.User.t
  -> unit
  -> [> Html_types.html ] Tyxml_html.elt
