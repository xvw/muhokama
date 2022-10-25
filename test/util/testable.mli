open Lib_common

val error : Error.t Alcotest.testable
val try_ : 'a Alcotest.testable -> 'a Try.t Alcotest.testable
val validate : 'a Alcotest.testable -> 'a Validate.t Alcotest.testable
val sha256 : Lib_crypto.Sha256.t Alcotest.testable
val migration : Lib_migration.Migration.t Alcotest.testable
val migration_file : Lib_migration.Migration.file Alcotest.testable
val migration_plan : Lib_migration.Plan.t Alcotest.testable
val saved_user : Models.User.t Alcotest.testable
val ptime : Ptime.t Alcotest.testable
val uri : Uri.t Alcotest.testable
