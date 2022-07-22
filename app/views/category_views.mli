val creation_form : string -> [> Html_types.form ] Tyxml_html.elt
val all : Models.Category.t list -> [> Html_types.table ] Tyxml_html.elt


(** a view for listing all categories grouped by their number of topics **)
val by_topics_count :
  ?flash_info:Models.Flash_info.t ->
  ?user:Models.User.t ->
  (string * string * int) list -> [> Html_types.html ] Tyxml_html.elt
