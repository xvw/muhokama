open Lib_common

let test ?(speed = `Quick) ~about ~desc f =
  Alcotest.test_case (Format.asprintf "%-42s%s" about desc) speed f
;;

let same testable ~expected ~computed =
  Alcotest.check testable "should be same" expected computed
;;

let error_testable = Alcotest.testable Error.pp Error.equal
let error_set_testable = Alcotest.testable Error.Set.pp Error.Set.equal
let try_testable t = Alcotest.result t error_testable

let validate_testable t =
  let ppx = Alcotest.pp t
  and eqx = Alcotest.equal t in
  Alcotest.testable (Validate.pp ppx) (Validate.equal eqx)
;;

let nel x xs =
  let open Preface.Nonempty_list in
  match from_list xs with
  | None -> Last x
  | Some xs -> x :: xs
;;
