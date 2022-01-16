open Muho_test_util
open Muho_stdlib
open Alcotest

let test_int_validation_valid =
  test
    ~about:"int"
    ~desc:
      "When the given input is a valid int, it should parse it and wrap it \
       into [valid]"
    (fun () ->
      let expected = Preface.Validate.valid 1678
      and computed = Provider.int "1678" in
      same (validate_testable int) ~computed ~expected)
;;

let test_int_validation_invalid =
  test
    ~about:"int"
    ~desc:"When the given input is not a valid int, it should return an error"
    (fun () ->
      let given_value = "16-78"
      and expected_type = "int" in
      let expected =
        Exn.(as_validation @@ Unexpected_value { given_value; expected_type })
      and computed = Provider.int given_value in
      same (validate_testable int) ~computed ~expected)
;;

let test_int_with_smaller_bound_valid =
  test
    ~about:"int & greater_than"
    ~desc:
      "When the given input is a valid int and greater than the given bound, \
       it should parse it and wrap it into [valid]"
    (fun () ->
      let expected = Preface.Validate.valid 999
      and computed = Provider.(int & greater_than 997) "999" in
      same (validate_testable int) ~computed ~expected)
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
        Exn.(as_validation @@ Int_too_small { given_value; min_bound })
      and computed =
        Provider.(int & greater_than min_bound) @@ string_of_int given_value
      in
      same (validate_testable int) ~computed ~expected)
;;

let test_int_with_smaller_bound_invalid_because_of_int =
  test
    ~about:"int & greater_than"
    ~desc:
      "When the given input is not a valid int, even with greater flag it \
       should return an error"
    (fun () ->
      let given_value = "16-78"
      and expected_type = "int" in
      let expected =
        Exn.(as_validation @@ Unexpected_value { given_value; expected_type })
      and computed = Provider.(int & greater_than 999) given_value in
      same (validate_testable int) ~computed ~expected)
;;

let test_int_with_greater_bound_valid =
  test
    ~about:"int & smaller_than"
    ~desc:
      "When the given input is a valid int and greater than the given bound, \
       it should parse it and wrap it into [valid]"
    (fun () ->
      let expected = Preface.Validate.valid 996
      and computed = Provider.(int & smaller_than 997) "996" in
      same (validate_testable int) ~computed ~expected)
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
        Exn.(as_validation @@ Int_too_large { given_value; max_bound })
      and computed =
        Provider.(int & smaller_than max_bound) @@ string_of_int given_value
      in
      same (validate_testable int) ~computed ~expected)
;;

let test_int_with_greater_bound_invalid_because_of_int =
  test
    ~about:"int & smaller_than"
    ~desc:
      "When the given input is not a valid int, even with smaller flag it \
       should return an error"
    (fun () ->
      let given_value = "16-78"
      and expected_type = "int" in
      let expected =
        Exn.(as_validation @@ Unexpected_value { given_value; expected_type })
      and computed = Provider.(int & smaller_than 999) given_value in
      same (validate_testable int) ~computed ~expected)
;;

let test_int_with_bound_valid =
  test
    ~about:"int & bounded"
    ~desc:
      "When the given input is a valid int and included in the given range, it \
       should parse it and wrap it into [valid]"
    (fun () ->
      let expected = Preface.Validate.valid 996
      and computed = Provider.(int & bounded 100 1000) "996" in
      same (validate_testable int) ~computed ~expected)
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
        Exn.(
          as_validation
          @@ Int_too_large { given_value; max_bound = succ max_bound })
      and computed =
        Provider.(int & bounded max_bound 0) @@ string_of_int given_value
      in
      same (validate_testable int) ~computed ~expected)
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
        Exn.(
          as_validation
          @@ Int_too_small { given_value; min_bound = pred min_bound })
      and computed =
        Provider.(int & bounded min_bound 1000) @@ string_of_int given_value
      in
      same (validate_testable int) ~computed ~expected)
;;

let test_int_with_bound_invalid_because_of_int =
  test
    ~about:"int & bounded"
    ~desc:
      "When the given input is not a valid int, even with greater flag it \
       should return an error"
    (fun () ->
      let given_value = "16-78"
      and expected_type = "int" in
      let expected =
        Exn.(as_validation @@ Unexpected_value { given_value; expected_type })
      and computed = Provider.(int & bounded 0 999) given_value in
      same (validate_testable int) ~computed ~expected)
;;

let test_string_not_empty_valid =
  test
    ~about:"string & not_empty"
    ~desc:
      "When the string is not empty it should return it wrapped into [valid]"
    (fun () ->
      let expected = Preface.Validate.valid "ok"
      and computed = Provider.(string & not_empty) "ok" in
      same (validate_testable string) ~computed ~expected)
;;

let test_string_not_empty_valid_even_blank =
  test
    ~about:"string & not_empty"
    ~desc:
      "When the string is not empty (but blank) it should return it wrapped \
       into [valid]"
    (fun () ->
      let expected = Preface.Validate.valid "    "
      and computed = Provider.(string & not_empty) "    " in
      same (validate_testable string) ~computed ~expected)
;;

let test_string_not_empty_invalid =
  test
    ~about:"string & not_empty"
    ~desc:"When the string is empty it should return an error"
    (fun () ->
      let expected = Exn.(as_validation String_is_empty)
      and computed = Provider.(string & not_empty) "" in
      same (validate_testable string) ~computed ~expected)
;;

let test_string_not_blank_valid =
  test
    ~about:"string & not_blank"
    ~desc:
      "When the string is not blank it should return it wrapped into [valid]"
    (fun () ->
      let expected = Preface.Validate.valid "ok"
      and computed = Provider.(string & not_blank) "ok" in
      same (validate_testable string) ~computed ~expected)
;;

let test_string_not_blank_invalid =
  test
    ~about:"string & not_blank"
    ~desc:"When the string is blank it should return an error"
    (fun () ->
      let expected = Exn.(as_validation @@ String_is_blank "      ")
      and computed = Provider.(string & not_blank) "      " in
      same (validate_testable string) ~computed ~expected)
;;

module User = struct
  module Store = Map.Make (String)

  type t =
    { id : string
    ; age : int option
    ; name : string option
    ; email : string
    }

  let pp ppf { id; age; name; email } =
    Pp.(
      record
        ppf
        [ field "id" id string
        ; field "age" age @@ Preface.Option.pp int
        ; field "name" name @@ Preface.Option.pp string
        ; field "email" email string
        ])
  ;;

  let equal a b =
    String.equal a.id b.id
    && Option.equal Int.equal a.age b.age
    && Option.equal String.equal a.name b.name
    && String.equal a.email b.email
  ;;

  let testable = Alcotest.testable pp equal
  let mk id age name email = { id; age; name; email }

  let validate =
    let open Provider in
    mk
    <$> required string "id"
    <*> optional (int & greater_than 7 & smaller_than 120) "age"
    <*> optional (string & not_blank) "name"
    <*> required (string & not_blank) "email"
  ;;

  let run store = Provider.run (fun key -> Store.find_opt key store) validate

  let store list =
    List.fold_left (fun s (k, v) -> Store.add k v s) Store.empty list
  ;;
end

let test_user_when_every_data_are_filled =
  test
    ~about:"Provider.run"
    ~desc:"When all data are given, it should wrap an user into [valid]"
    (fun () ->
      let store =
        User.store
          [ "id", "xvw"
          ; "age", "32"
          ; "name", "Vdw"
          ; "email", "xavier@mail.com"
          ]
      in
      let expected =
        Preface.Validate.valid
        @@ User.mk "xvw" (Some 32) (Some "Vdw") "xavier@mail.com"
      and computed = User.run store in
      same (validate_testable User.testable) ~expected ~computed)
;;

let test_user_when_some_data_are_filled =
  test
    ~about:"Provider.run"
    ~desc:
      "When all required data are given, it should wrap an user into [valid]"
    (fun () ->
      let store = User.store [ "id", "xvw"; "email", "xavier@mail.com" ] in
      let expected =
        Preface.Validate.valid @@ User.mk "xvw" None None "xavier@mail.com"
      and computed = User.run store in
      same (validate_testable User.testable) ~expected ~computed)
;;

let test_user_when_all_data_are_missing =
  test
    ~about:"Provider.run"
    ~desc:"When all required data are missing, it should return an error"
    (fun () ->
      let store =
        User.store [ "an_id", "xvw"; "an_email", "xavier@mail.com" ]
      in
      let expected =
        Exn.(errors (Required_field "email") [ Required_field "id" ])
      and computed = User.run store in
      same (validate_testable User.testable) ~expected ~computed)
;;

let test_user_when_there_is_some_errors =
  test
    ~about:"Provider.run"
    ~desc:"When there is errors, it should return an error"
    (fun () ->
      let store =
        User.store
          [ "an_id", "xvw"
          ; "an_email", "xavier@mail.com"
          ; "age", "-12"
          ; "name", "   "
          ]
      in
      let expected =
        Exn.(
          errors
            (Required_field "email")
            [ Invalid_field
                { key = "name"; errors = nel (String_is_blank "   ") [] }
            ; Invalid_field
                { key = "age"
                ; errors =
                    nel (Int_too_small { given_value = -12; min_bound = 7 }) []
                }
            ; Required_field "id"
            ])
      and computed = User.run store in
      same (validate_testable User.testable) ~expected ~computed)
;;

let cases =
  ( "Provider"
  , [ test_int_validation_valid
    ; test_int_validation_invalid
    ; test_int_with_smaller_bound_valid
    ; test_int_with_smaller_bound_invalid
    ; test_int_with_smaller_bound_invalid_because_of_int
    ; test_int_with_greater_bound_valid
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
