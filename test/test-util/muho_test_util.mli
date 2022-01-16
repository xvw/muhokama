(** An helper for test definition.*)
val test
  :  ?speed:Alcotest.speed_level
  -> about:string
  -> desc:string
  -> ('a -> unit)
  -> 'a Alcotest.test_case

(** An helper for checking equalities.*)
val same : 'a Alcotest.testable -> expected:'a -> computed:'a -> unit

(** Helper for creating Nonempty list. *)
val nel : 'a -> 'a list -> 'a Preface.Nonempty_list.t

(** Helper for creating error side of validation. *)
val errors
  :  Muho_stdlib.Exn.t
  -> Muho_stdlib.Exn.t list
  -> 'a Preface.Validate.t

(** {1 Testables}*)

val exn_testable : Muho_stdlib.Exn.t Alcotest.testable

val validate_testable
  :  'a Alcotest.testable
  -> 'a Preface.Validate.t Alcotest.testable
