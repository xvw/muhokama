open Lib_common

val static_css : Opium.App.t -> Opium.App.t Try.t Lwt.t
val static_images : Opium.App.t -> Opium.App.t Try.t Lwt.t
val database : Lib_common.Env.t -> Opium.App.t -> Opium.App.t Try.t Lwt.t

val use_pool
  :  Rock.Request.t
  -> (Caqti_lwt.connection -> ('a, Caqti_error.t) result Lwt.t)
  -> ('a, Error.t) result Lwt.t
