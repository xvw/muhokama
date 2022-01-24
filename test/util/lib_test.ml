open Lib_common

let test ?(speed = `Quick) ~about ~desc f =
  Alcotest.test_case (Format.asprintf "%-42s%s" about desc) speed f
;;

let same testable ~expected ~computed =
  Alcotest.check testable "should be same" expected computed
;;

let nel x xs =
  let open Preface.Nonempty_list in
  match from_list xs with
  | None -> Last x
  | Some xs -> x :: xs
;;

let error_testable = Alcotest.testable Error.pp Error.equal
let error_set_testable = Alcotest.testable Error.Set.pp Error.Set.equal
let try_testable t = Alcotest.result t error_testable

let validate_testable t =
  let ppx = Alcotest.pp t
  and eqx = Alcotest.equal t in
  Alcotest.testable (Validate.pp ppx) (Validate.equal eqx)
;;

let sha256_testable =
  let open Lib_crypto in
  Alcotest.testable Sha256.pp Sha256.equal
;;

let migration_testable =
  let open Lib_migration in
  Alcotest.testable Migration.pp Migration.equal
;;

let step_eq a b =
  let open Lib_migration in
  match a, b with
  | Context.Up la, Context.Up lb ->
    List.equal
      (fun a b -> Int.equal (fst a) (fst b) && Migration.equal (snd a) (snd b))
      la
      lb
  | Context.Down (la, (ax, ay)), Context.Down (lb, (bx, by)) ->
    List.equal
      (fun a b -> Int.equal (fst a) (fst b) && Migration.equal (snd a) (snd b))
      la
      lb
    && Int.equal ax bx
    && Lib_crypto.Sha256.equal ay by
  | Nothing, Nothing -> true
  | _ -> false
;;

let step_pp ppf =
  let open Lib_migration in
  function
  | Context.Nothing -> Format.fprintf ppf "Nothing"
  | Up li -> Format.fprintf ppf "Up %a" Fmt.(list (pair int Migration.pp)) li
  | Down (li, (i, h)) ->
    Format.fprintf
      ppf
      "Down %a, (%d, %a)"
      Fmt.(list (pair int Migration.pp))
      li
      i
      Lib_crypto.Sha256.pp
      h
;;

let step_testable = Alcotest.testable step_pp step_eq
let t_step_testable = try_testable step_testable

module User = struct
  type t =
    { id : string
    ; age : int option
    ; name : string option
    ; email : string
    }

  let pp ppf { id; age; name; email } =
    Format.fprintf
      ppf
      "%s;%a;%a;%s"
      id
      Fmt.(option int)
      age
      Fmt.(option string)
      name
      email
  ;;

  let equal a b =
    String.equal a.id b.id
    && Option.equal Int.equal a.age b.age
    && Option.equal String.equal a.name b.name
    && String.equal a.email b.email
  ;;

  let testable = Alcotest.testable pp equal
  let make id age name email = { id; age; name; email }
end
