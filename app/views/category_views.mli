module Category :
  sig
    val category_name_input : [> Html_types.div ] Tyxml_html.elt
    val category_description_input : [> Html_types.div ] Tyxml_html.elt
    val submit_button : [> Html_types.div ] Tyxml_html.elt
    val creation_form : string -> [> Html_types.form ] Tyxml_html.elt
    val category_line :
      Models.Category.t -> [> Html_types.tr ] Tyxml_html.elt
    val all : Models.Category.t list -> [> Html_types.table ] Tyxml_html.elt
  end

(** a view for listing all categories **)
val categories :
  ?flash_info:Models.Flash_info.t ->
  ?user:Models.User.t ->
  Models.Category.t list -> [> Html_types.html ] Tyxml_html.elt
