open Lib_common

(** [set_user_id request user] set the connected user session. *)
val set_current_user : Dream.request -> Model.User.t -> unit Try.t Lwt.t

(** Resolves the current connected user.*)
val get_connected_user_id : Dream.request -> string option
