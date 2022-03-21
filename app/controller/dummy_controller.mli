(** A dummy set of controllers (mostly for testing) *)

(** The controller for a dummy service that just print [Hello World]. *)
val hello_world : Model.User.Saved.t -> Dream.handler
