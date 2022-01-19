(** {1 Test definition} *)

(** An helper for test definition.*)
val test
  :  ?speed:Alcotest.speed_level
  -> about:string
  -> desc:string
  -> ('a -> unit)
  -> 'a Alcotest.test_case

(** An helper for checking equalities.*)
val same : 'a Alcotest.testable -> expected:'a -> computed:'a -> unit

(** {1 Testables} *)

val error_testable : Muhokama.Error.t Alcotest.testable
val error_set_testable : Muhokama.Error.Set.t Alcotest.testable
val try_testable : 'a Alcotest.testable -> 'a Muhokama.Try.t Alcotest.testable

val validate_testable
  :  'a Alcotest.testable
  -> 'a Muhokama.Validate.t Alcotest.testable
