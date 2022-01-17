(** Helper for dealing with Database. *)

(** Build the [uri] locating the database. *)
val make_uri
  :  user:string
  -> password:string
  -> host:string
  -> port:int
  -> database:string
  -> Uri.t

(** Create a pool of connection for the database. *)
val connect
  :  max_size:int
  -> user:string
  -> password:string
  -> host:string
  -> port:int
  -> database:string
  -> (Caqti_lwt.connection, [> Caqti_error.connect ]) Caqti_lwt.Pool.t
     Preface.Try.t
     Lwt.t

(** Lift Caqti result into a [Preface.Try.t]. *)
val as_try : ('a, [< Caqti_error.t ]) result Lwt.t -> 'a Preface.Try.t Lwt.t

val use
  :  ('a, ([< Caqti_error.t ] as 'b)) Caqti_lwt.Pool.t
  -> ('a -> ('c, 'b) result Lwt.t)
  -> 'c Preface.Try.t Lwt.t
