(** Provide the [Env] through HTTP request. *)

val set : Lib_common.Env.t -> Dream.middleware
val get : Dream.request -> (Lib_common.Env.t -> 'a) -> 'a
