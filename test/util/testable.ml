open Lib_common

let error = Alcotest.testable Error.pp Error.equal
let try_ t = Alcotest.result t error

let validate t =
  let ppx = Alcotest.pp t
  and eqx = Alcotest.equal t in
  Alcotest.testable (Validate.pp ppx) (Validate.equal eqx)
;;

let sha256 =
  let open Lib_crypto in
  Alcotest.testable Sha256.pp Sha256.equal
;;

let migration =
  let open Lib_migration in
  Alcotest.testable Migration.pp Migration.equal
;;

let migration_file =
  let open Lib_migration in
  Alcotest.testable Migration.pp_file Migration.equal_file
;;

let migration_plan =
  let open Lib_migration in
  Alcotest.testable Plan.pp Plan.equal
;;

let saved_user =
  let open Model.User in
  Alcotest.testable Saved.pp Saved.equal
;;
