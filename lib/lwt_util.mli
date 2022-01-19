(** Helper for Lwt. *)

(** {1 Promoting values} *)

val return : 'a -> 'a Lwt.t
val pure : 'a -> 'a Lwt.t
val return_ok : 'a -> ('a, 'b) Result.t Lwt.t

(** {1 Lifting} *)

val map : ('a -> 'b) -> 'a Lwt.t -> 'b Lwt.t
val bind : ('a -> 'b Lwt.t) -> 'a Lwt.t -> 'b Lwt.t
val map_ok : ('a -> 'b) -> ('a, 'c) Result.t Lwt.t -> ('b, 'c) Result.t Lwt.t

val bind_ok
  :  ('a -> ('b, 'c) Result.t Lwt.t)
  -> ('a, 'c) Result.t Lwt.t
  -> ('b, 'c) Result.t Lwt.t

(** {1 Infix operators} *)

val ( >|= ) : 'a Lwt.t -> ('a -> 'b) -> 'b Lwt.t
val ( >>= ) : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t
val ( >|=? ) : ('a, 'c) Result.t Lwt.t -> ('a -> 'b) -> ('b, 'c) Result.t Lwt.t

val ( >>=? )
  :  ('a, 'c) Result.t Lwt.t
  -> ('a -> ('b, 'c) Result.t Lwt.t)
  -> ('b, 'c) Result.t Lwt.t

(** {1 Let operators} *)

val ( let+ ) : 'a Lwt.t -> ('a -> 'b) -> 'b Lwt.t
val ( let* ) : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t
val ( let+? ) : ('a, 'c) Result.t Lwt.t -> ('a -> 'b) -> ('b, 'c) Result.t Lwt.t

val ( let*? )
  :  ('a, 'c) Result.t Lwt.t
  -> ('a -> ('b, 'c) Result.t Lwt.t)
  -> ('b, 'c) Result.t Lwt.t
