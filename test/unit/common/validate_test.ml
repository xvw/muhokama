open Lib_test
open Lib_common
open Alcotest
module V = Validate
module F = V.Free

let test_int_validation_valid =
  test
    ~about:"int"
    ~desc:
      "When the given input is a valid int, it should parse it and wrap it \
       into [valid]"
    (fun () ->
      let expected = Validate.valid 1678
      and computed = F.int "1678" in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_validation_invalid =
  test
    ~about:"int"
    ~desc:"When the given input is not a valid int, it should return an error"
    (fun () ->
      let given_value = "16-78"
      and target = "int" in
      let expected =
        Error.(
          to_validate
          @@ validation_unconvertible_string ~given_value ~target_type:target)
      and computed = F.int given_value in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_with_smaller_bound_valid =
  test
    ~about:"int & greater_than"
    ~desc:
      "When the given input is a valid int and greater than the given bound, \
       it should parse it and wrap it into [valid]"
    (fun () ->
      let expected = Validate.valid 999
      and computed = V.(F.(int & greater_than 997) "999") in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_with_smaller_bound_invalid =
  test
    ~about:"int & greater_than"
    ~desc:
      "When the given input is a valid int and smaller than the given bound, \
       it should parse it should return an error"
    (fun () ->
      let given_value = 9
      and min_bound = 997 in
      let expected =
        Error.(
          to_validate @@ validation_is_smaller_than ~given_value ~min_bound)
      and computed =
        V.(F.(int & greater_than min_bound)) @@ string_of_int given_value
      in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_with_smaller_bound_invalid_because_of_int =
  test
    ~about:"int & greater_than"
    ~desc:
      "When the given input is not a valid int, even with greater flag it \
       should return an error"
    (fun () ->
      let given_value = "16-78"
      and target = "int" in
      let expected =
        Error.(
          to_validate
          @@ validation_unconvertible_string ~given_value ~target_type:target)
      and computed = V.(F.(int & greater_than 999)) given_value in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_with_greater_bound_invalid =
  test
    ~about:"int & smaller_than"
    ~desc:
      "When the given input is a valid int and greater than the given bound, \
       it should parse it should return an error"
    (fun () ->
      let given_value = 9999
      and max_bound = 997 in
      let expected =
        Error.(
          to_validate @@ validation_is_greater_than ~given_value ~max_bound)
      and computed =
        V.(F.(int & smaller_than max_bound)) @@ string_of_int given_value
      in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_with_greater_bound_invalid_because_of_int =
  test
    ~about:"int & smaller_than"
    ~desc:
      "When the given input is not a valid int, even with smaller flag it \
       should return an error"
    (fun () ->
      let given_value = "16-78"
      and target = "int" in
      let expected =
        Error.(
          to_validate
          @@ validation_unconvertible_string ~given_value ~target_type:target)
      and computed = V.(F.(int & smaller_than 999)) given_value in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_with_bound_valid =
  test
    ~about:"int & bounded"
    ~desc:
      "When the given input is a valid int and included in the given range, it \
       should parse it and wrap it into [valid]"
    (fun () ->
      let expected = Validate.valid 996
      and computed = V.(F.(int & bounded_to 100 1000)) "996" in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_with_bound_invalid =
  test
    ~about:"int & bounded"
    ~desc:
      "When the given input is a valid int and greater than the max bound, it \
       should parse it should return an error"
    (fun () ->
      let given_value = 9999
      and max_bound = 997 in
      let expected =
        Error.(
          to_validate
          @@ validation_is_greater_than ~given_value ~max_bound:(succ max_bound))
      and computed =
        V.(F.(int & bounded_to max_bound 0)) @@ string_of_int given_value
      in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_with_bound_invalid_because_of_smaller =
  test
    ~about:"int & bounded"
    ~desc:
      "When the given input is a valid int and smaller than the min bound, it \
       should parse it should return an error"
    (fun () ->
      let given_value = 100
      and min_bound = 997 in
      let expected =
        Error.(
          to_validate
          @@ validation_is_smaller_than ~given_value ~min_bound:(pred min_bound))
      and computed =
        V.(F.(int & bounded_to min_bound 1000)) @@ string_of_int given_value
      in
      same (Testable.validate int) ~computed ~expected)
;;

let test_int_with_bound_invalid_because_of_int =
  test
    ~about:"int & bounded"
    ~desc:
      "When the given input is not a valid int, even with greater flag it \
       should return an error"
    (fun () ->
      let given_value = "16-78"
      and target = "int" in
      let expected =
        Error.(
          to_validate
          @@ validation_unconvertible_string ~given_value ~target_type:target)
      and computed = V.(F.(int & bounded_to 0 999)) given_value in
      same (Testable.validate int) ~computed ~expected)
;;

let test_string_not_empty_valid =
  test
    ~about:"string & not_empty"
    ~desc:
      "When the string is not empty it should return it wrapped into [valid]"
    (fun () ->
      let expected = Validate.valid "ok"
      and computed = V.(F.(string & not_empty)) "ok" in
      same (Testable.validate string) ~computed ~expected)
;;

let test_string_not_empty_valid_even_blank =
  test
    ~about:"string & not_empty"
    ~desc:
      "When the string is not empty (but blank) it should return it wrapped \
       into [valid]"
    (fun () ->
      let expected = Validate.valid "    "
      and computed = V.(F.(string & not_empty)) "    " in
      same (Testable.validate string) ~computed ~expected)
;;

let test_string_not_empty_invalid =
  test
    ~about:"string & not_empty"
    ~desc:"When the string is empty it should return an error"
    (fun () ->
      let expected = Error.(to_validate @@ validation_is_empty)
      and computed = V.(F.(string & not_empty)) "" in
      same (Testable.validate string) ~computed ~expected)
;;

let test_string_not_blank_valid =
  test
    ~about:"string & not_blank"
    ~desc:
      "When the string is not blank it should return it wrapped into [valid]"
    (fun () ->
      let expected = Validate.valid "ok"
      and computed = V.(F.(string & not_blank)) "ok" in
      same (Testable.validate string) ~computed ~expected)
;;

let test_string_not_blank_invalid =
  test
    ~about:"string & not_blank"
    ~desc:"When the string is blank it should return an error"
    (fun () ->
      let expected = Error.(to_validate @@ validation_is_blank)
      and computed = V.(F.(string & not_blank)) "      " in
      same (Testable.validate string) ~computed ~expected)
;;

module Individual = struct
  include Individual
  module Store = Map.Make (String)

  let validate =
    let open Validate in
    let open Free in
    make
    <$> required string "id"
    <*> optional (int & greater_than 7 & smaller_than 120) "age"
    <*> optional (string & not_blank) "name"
    <*> required (string & not_blank) "email"
  ;;

  let run ?name store =
    Validate.Free.run ?name (fun key -> Store.find_opt key store) validate
  ;;

  let store list =
    List.fold_left (fun s (k, v) -> Store.add k v s) Store.empty list
  ;;
end

let test_user_when_every_data_are_filled =
  test
    ~about:"Validate.Free.run"
    ~desc:"When all data are given, it should wrap an user into [valid]"
    (fun () ->
      let store =
        Individual.store
          [ "id", "xvw"
          ; "age", "32"
          ; "name", "Vdw"
          ; "email", "xavier@mail.com"
          ]
      in
      let expected =
        Ok (Individual.make "xvw" (Some 32) (Some "Vdw") "xavier@mail.com")
      and computed = Individual.run ~name:"user" store in
      same (Testable.try_ Individual.testable) ~expected ~computed)
;;

let test_user_when_some_data_are_filled =
  test
    ~about:"Validate.Free.run"
    ~desc:
      "When all required data are given, it should wrap an user into [valid]"
    (fun () ->
      let store =
        Individual.store [ "id", "xvw"; "email", "xavier@mail.com" ]
      in
      let expected = Ok (Individual.make "xvw" None None "xavier@mail.com")
      and computed = Individual.run store in
      same (Testable.try_ Individual.testable) ~expected ~computed)
;;

let test_user_when_all_data_are_missing =
  test
    ~about:"Validate.Free.run"
    ~desc:"When all required data are missing, it should return an error"
    (fun () ->
      let store =
        Individual.store [ "an_id", "xvw"; "an_email", "xavier@mail.com" ]
      in
      let expected =
        Try.error
          Error.(
            Invalid_object
              { name = "user"
              ; errors =
                  nel
                    (Field (Missing { name = "email" }))
                    [ Field (Missing { name = "id" }) ]
              })
      and computed = Individual.run ~name:"user" store in
      same (Testable.try_ Individual.testable) ~expected ~computed)
;;

let test_user_when_there_is_some_errors =
  test
    ~about:"Validate.Free.run"
    ~desc:"When there is errors, it should return an error"
    (fun () ->
      let store =
        Individual.store
          [ "an_id", "xvw"
          ; "an_email", "xavier@mail.com"
          ; "age", "-12"
          ; "name", "   "
          ]
      in
      let expected =
        Try.error
          Error.(
            Invalid_object
              { name = "user"
              ; errors =
                  nel
                    (Field (Missing { name = "email" }))
                    [ Field
                        (Invalid
                           { name = "name"
                           ; errors = nel (Validation Is_blank) []
                           })
                    ; Field
                        (Invalid
                           { name = "age"
                           ; errors =
                               nel
                                 (Validation
                                    (Is_smaller_than
                                       { min_bound = 7; given_value = -12 }))
                                 []
                           })
                    ; Field (Missing { name = "id" })
                    ]
              })
      and computed = Individual.run ~name:"user" store in
      same (Testable.try_ Individual.testable) ~expected ~computed)
;;

let cases =
  ( "Validate and Free Validate"
  , [ test_int_validation_valid
    ; test_int_validation_invalid
    ; test_int_with_smaller_bound_valid
    ; test_int_with_smaller_bound_invalid
    ; test_int_with_smaller_bound_invalid_because_of_int
    ; test_int_with_greater_bound_invalid
    ; test_int_with_greater_bound_invalid_because_of_int
    ; test_int_with_bound_valid
    ; test_int_with_bound_invalid
    ; test_int_with_bound_invalid_because_of_int
    ; test_int_with_bound_invalid_because_of_smaller
    ; test_string_not_empty_valid
    ; test_string_not_empty_invalid
    ; test_string_not_empty_valid_even_blank
    ; test_string_not_blank_valid
    ; test_string_not_blank_invalid
    ; test_user_when_every_data_are_filled
    ; test_user_when_some_data_are_filled
    ; test_user_when_all_data_are_missing
    ; test_user_when_there_is_some_errors
    ] )
;;
