open Tyxml

val page
  :  lang:string
  -> page_title:string
  -> ?charset:string
  -> ?additional_meta:[< Html_types.meta_attrib ] Html.attrib list list
  -> ?additional_css:string list
  -> ?flash:Notif.t
  -> [< Html_types.flow5 ] Html.elt list
  -> [> Html_types.html ] Html.elt
