(** Components are reusable blocks that can be used in multiple templates (and
    in the global layout)*)

open Tyxml

(** Returns the main header of the forum. (Present in the global layout) *)
val main_header : [> Html_types.header ] Html.elt

(** Returns the main footer of the forum. (Present in the global layout) *)
val main_footer : [> Html_types.footer ] Html.elt

(** Returns the navbar when the user is not connected. (Present in the global
    layout) *)
val navbar : Models.User.t option -> [> Html_types.nav ] Html.elt

(** [flash_info potential_info] display (or not) the topbar where flash info are
    displayed. *)
val flash_info : Models.Flash_info.t option -> [> Html_types.div ] Html.elt

(** Render an user state to a visual tag. *)
val user_state_tag : Models.User.State.t -> [> Html_types.span ] Html.elt

val avatar
  :  ?default:Lib_common.Gravatar.default_style
  -> ?size:int
  -> email:string
  -> username:string
  -> unit
  -> [> Html_types.img ] Html.elt
