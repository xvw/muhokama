(** A layout is multiple components assembled for forming a complete page
    structure. *)

open Tyxml

(** Generate the default layout.

    [default] is taylored for working with the default webdesign. So it bundle
    some CSS stuff and is very biased about some metadata. You can give
    [prefix_title] for having a title scheme. Ie:
    [default ~prefix_title:(Some "Muhokama - ") ~page_title:"Hello World"] will
    render this title: "Muhokama - Hello World". *)
val default
  :  lang:string
  -> page_title:string
  -> ?prefix_title:string option
  -> ?charset:string
  -> ?additional_meta:[< Html_types.meta_attrib ] Html.attrib list list
  -> ?additional_css:string list
  -> ?flash_info:Model.Flash_info.t
  -> ?user:Model.User.t
  -> [< Html_types.flow5 ] Html.elt list
  -> [> Html_types.html ] Html.elt
