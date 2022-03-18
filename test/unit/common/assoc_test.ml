open Lib_common
open Lib_test

module Individual = struct
  include Individual

  let create (type t) (module R : Intf.VALIDABLE_ASSOC with type t = t) assoc =
    let open Validate in
    R.object_and
      (fun obj ->
        make
        <$> R.(obj |> required string "id")
        <*> R.(obj |> optional int "age")
        <*> R.(obj |> optional string "name")
        <*> R.(obj |> required string "email"))
      assoc
    |> R.run ~name:"user"
  ;;

  let from_jsnonm = create (module Assoc.Jsonm)

  let json ?id ?age ?name ?email () =
    `O
      [ "id", Option.fold ~none:`Null ~some:(fun x -> `String x) id
      ; ( "age"
        , Option.fold ~none:`Null ~some:(fun x -> `Float (float_of_int x)) age )
      ; "name", Option.fold ~none:`Null ~some:(fun x -> `String x) name
      ; "email", Option.fold ~none:`Null ~some:(fun x -> `String x) email
      ]
  ;;
end

let test_create_a_valid_user =
  test
    ~about:"run"
    ~desc:"When all data are given, the result should be valid"
    (fun () ->
      let json_user =
        Individual.json
          ~id:"xvw"
          ~age:32
          ~name:"Vdw"
          ~email:"xavier@mail.com"
          ()
      in
      let expected =
        Ok (Individual.make "xvw" (Some 32) (Some "Vdw") "xavier@mail.com")
      and computed = Individual.from_jsnonm json_user in
      same (try_testable Individual.testable) ~expected ~computed)
;;

let test_create_a_valid_user_without_optional_values =
  test
    ~about:"run"
    ~desc:"When all data required are given, the result should be valid"
    (fun () ->
      let json_user = Individual.json ~id:"xvw" ~email:"xavier@mail.com" () in
      let expected = Ok (Individual.make "xvw" None None "xavier@mail.com")
      and computed = Individual.from_jsnonm json_user in
      same (try_testable Individual.testable) ~expected ~computed)
;;

let test_create_an_invalid_user_without_any_values =
  test
    ~about:"run"
    ~desc:"When no data is given, the result should be invalid"
    (fun () ->
      let json_user = Individual.json () in
      let expected =
        Try.error
          Error.(
            Invalid_object
              { name = "user"
              ; errors =
                  nel
                    (Field (Missing { name = "id" }))
                    [ Field (Missing { name = "email" }) ]
              })
      and computed = Individual.from_jsnonm json_user in
      same (try_testable Individual.testable) ~expected ~computed)
;;

let cases =
  ( "Assoc Validation"
  , [ test_create_a_valid_user
    ; test_create_a_valid_user_without_optional_values
    ; test_create_an_invalid_user_without_any_values
    ] )
;;
