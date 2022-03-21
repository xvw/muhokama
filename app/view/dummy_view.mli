(** A dummy set of views (mostly for testing) *)

(** The view for a dummy service that just print [Hello World]. *)
val hello_world
  :  ?flash_info:Model.Flash_info.t
  -> ?user:Model.User.Saved.t
  -> unit
  -> Tyxml.Html.doc
