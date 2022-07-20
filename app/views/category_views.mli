val category_name_input : [> Html_types.div ] Tyxml_html.elt
val category_description_input : [> Html_types.div ] Tyxml_html.elt
val submit_button : [> Html_types.div ] Tyxml_html.elt
val creation_form : string -> [> Html_types.form ] Tyxml_html.elt
val category_line : Models.Category.t -> [> Html_types.tr ] Tyxml_html.elt
val category_topics_count_line :
  string * string * int -> [> Html_types.tr ] Tyxml_html.elt
val all : Models.Category.t list -> [> Html_types.table ] Tyxml_html.elt

(** a view for listing all categories **)
val categories :
  ?flash_info:Models.Flash_info.t ->
  ?user:Models.User.t ->
  Models.Category.t list -> [> Html_types.html ] Tyxml_html.elt

(** a view for listing all categories grouped by their number of topics **)
val categories_by_topics_count :
  ?flash_info:Models.Flash_info.t ->
  ?user:Models.User.t ->
  (string * string * int) list -> [> Html_types.html ] Tyxml_html.elt
