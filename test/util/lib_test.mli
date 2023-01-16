(** {1 Test definition} *)
open Lib_common

(** An helper for test definition.*)
val test
  :  ?speed:Alcotest.speed_level
  -> about:string
  -> desc:string
  -> ('a -> unit)
  -> 'a Alcotest.test_case

val integration_test
  :  ?migrations_path:string
  -> ?speed:Alcotest.speed_level
  -> about:string
  -> desc:string
  -> (Env.t -> Caqti_lwt.connection -> 'a Try.t Lwt.t)
  -> ('a Try.t -> unit)
  -> unit Alcotest.test_case

(** An helper for checking equalities.*)
val same : 'a Alcotest.testable -> expected:'a -> computed:'a -> unit

(** [delayed ~time f] will perform [f] after awaiting [time]. *)
val delayed : ?time:float -> (unit -> 'a Lwt.t) -> 'a Lwt.t

(** {1 Testables} *)

module Testable = Testable

(** {1 diverses Helpers} *)

val nel : 'a -> 'a list -> 'a Preface.Nonempty_list.t

(** {1 model helpers} *)

val user_for_registration
  :  string
  -> string
  -> string
  -> string
  -> Models.User.registration_form Try.t

val category_for_creation
  :  string
  -> string
  -> Models.Category.creation_form Try.t

val user_for_connection : string -> string -> Models.User.connection_form Try.t

val shared_link_for_creation
  :  string
  -> string
  -> Models.Shared_link.creation_form Try.t

val user_for_update_preferences
  :  string
  -> string
  -> Models.User.t
  -> Models.User.update_preference_form Try.t

val user_for_update_password
  :  string
  -> string
  -> Models.User.t
  -> Models.User.update_password_form Try.t

val make_user
  :  ?state:Models.User.State.t
  -> string
  -> string
  -> string
  -> Caqti_lwt.connection
  -> Models.User.t Try.t Lwt.t

val create_category
  :  string
  -> string
  -> Caqti_lwt.connection
  -> unit Try.t Lwt.t

val create_categories
  :  Caqti_lwt.connection
  -> (Models.Category.t * Models.Category.t * Models.Category.t) Try.t Lwt.t

val create_users
  :  Caqti_lwt.connection
  -> (Models.User.t * Models.User.t * Models.User.t * Models.User.t) Try.t Lwt.t

val create_topic
  :  string
  -> Models.User.t
  -> string
  -> string
  -> Caqti_lwt.connection
  -> string Try.t Lwt.t

val update_topic
  :  string
  -> string
  -> string
  -> string
  -> Caqti_lwt.connection
  -> unit Try.t Lwt.t

val create_message
  :  Models.User.t
  -> string
  -> string
  -> Caqti_lwt.connection
  -> string Try.t Lwt.t

val create_shared_link
  :  Models.User.t
  -> string
  -> string
  -> Caqti_lwt.connection
  -> unit Try.t Lwt.t

(** {1 Some data} *)

module Individual : sig
  type t =
    { id : string
    ; age : int option
    ; name : string option
    ; email : string
    }

  val pp : t Fmt.t
  val equal : t -> t -> bool
  val testable : t Alcotest.testable
  val make : string -> int option -> string option -> string -> t
end
