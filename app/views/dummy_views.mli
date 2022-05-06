(** A dummy set of views (mostly for testing) *)

(** The view for a dummy service that just print [Hello World]. *)
val hello_world
  :  ?flash_info:Models.Flash_info.t
  -> ?user:Models.User.t
  -> unit
  -> Tyxml.Html.doc
