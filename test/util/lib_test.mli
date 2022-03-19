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
  -> Model.User.For_registration.t Try.t

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
