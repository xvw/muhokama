open Muhokama

let test ?(speed = `Quick) ~about ~desc f =
  Alcotest.test_case (Format.asprintf "%-42s%s" about desc) speed f
;;

let same testable ~expected ~computed =
  Alcotest.check testable "should be same" expected computed
;;

let exn_testable = Alcotest.testable Exn.pp Exn.equal

let validate_testable t =
  let ppx = Alcotest.pp t
  and eqx = Alcotest.equal t in
  Alcotest.testable
    (Preface.Validation.pp ppx (Preface.Nonempty_list.pp Exn.pp))
    (Preface.Validation.equal eqx (Preface.Nonempty_list.equal Exn.equal))
;;

let nel x xs =
  let open Preface.Nonempty_list in
  match from_list xs with
  | None -> Last x
  | Some xs -> x :: xs
;;

let errors x xs = nel x xs |> Preface.Validate.invalid
