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
  -> (Env.t
      -> Caqti_error.t Lib_db.connection
      -> (Caqti_error.t Lib_db.connection * 'a) Try.t Lwt.t)
  -> ('a -> unit)
  -> unit Alcotest.test_case

(** An helper for checking equalities.*)
val same : 'a Alcotest.testable -> expected:'a -> computed:'a -> unit

(** {1 Testables} *)

val error_testable : Error.t Alcotest.testable
val error_set_testable : Error.Set.t Alcotest.testable
val try_testable : 'a Alcotest.testable -> 'a Try.t Alcotest.testable
val validate_testable : 'a Alcotest.testable -> 'a Validate.t Alcotest.testable
val sha256_testable : Lib_crypto.Sha256.t Alcotest.testable
val migration_testable : Lib_migration.Migration.t Alcotest.testable
val step_testable : Lib_migration.Context.step Alcotest.testable
val t_step_testable : Lib_migration.Context.step Try.t Alcotest.testable

(** {1 diverses Helpers} *)

val nel : 'a -> 'a list -> 'a Preface.Nonempty_list.t

(** {1 Some data} *)

module User : sig
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
