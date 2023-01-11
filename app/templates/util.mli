open Tyxml

val preconnect : ?crossorigin:bool -> string -> [> Html_types.link ] Html.elt
val stylesheet : string -> [> Html_types.link ] Html.elt
val csrf_input : string -> [> Html_types.input ] Html.elt

val a
  :  ?a:[< Html_types.a_attrib > `Href ] Tyxml_html.attrib list
  -> ([ `GET ], 'a, [> 'b Html_types.a ] Tyxml_html.elt) Lib_service.Endpoint.t
  -> 'b Tyxml_html.elt list
  -> 'a

val form
  :  ?a:[< Html_types.form_attrib > `Action `Method ] Tyxml_html.attrib list
  -> ?csrf_token:string
  -> ?anchor:string
  -> ('a, 'b, [> Html_types.form ] Tyxml_html.elt) Lib_service.Endpoint.t
  -> [< Html_types.form_content_fun > `Input ] Tyxml_html.elt list
  -> 'b

val format_date : Ptime.t -> string

val with_tooltip
  :  [< Html_types.div_content_fun > `Span ] Html.elt
  -> string
  -> [> Html_types.div ] Html.elt
