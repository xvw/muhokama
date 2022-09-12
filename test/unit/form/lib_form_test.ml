open Alcotest
open Lib_test
open Lib_common

let user_form post =
  let open Lib_form in
  let+ user_id = required post "id" is_uuid
  and+ age = optional post "age" (is_int &> bounded_to 7 99)
  and+ name = optional post "name" not_blank
  and+ email = required post "email" is_email
  and+ () = required post "checked_rules" (is_bool &> is_true) in
  Individual.make user_id age name email
;;

let validator_cases =
  ( "validator"
  , [ test
        ~about:"algebra &&"
        ~desc:"composition of validator using &&"
        (fun () ->
        let open Lib_form in
        let a = from_predicate ~message:">10" (fun x -> x > 10)
        and b = from_predicate ~message:"<20" (fun x -> x < 20) in
        let validator = a &> b in
        let expected = Validate.valid 15
        and computed = run_validator validator 15 in
        let () = same (Testable.validate int) ~expected ~computed in
        let expected =
          Error.(
            to_validate @@ validation_invalid_predicate ~with_message:">10")
        and computed = run_validator validator 10 in
        let () = same (Testable.validate int) ~expected ~computed in
        let expected =
          Error.(
            to_validate @@ validation_invalid_predicate ~with_message:"<20")
        and computed = run_validator validator 21 in
        let () = same (Testable.validate int) ~expected ~computed in
        ())
    ; test
        ~about:"algebra ||"
        ~desc:"composition of validator using ||"
        (fun () ->
        let open Lib_form in
        let a = from_predicate ~message:">10" (fun x -> x > 10)
        and b = from_predicate ~message:"<20" (fun x -> x < 20)
        and c = from_predicate ~message:">100" (fun x -> x > 100) in
        let validator = a &> b <|> c in
        let expected = Validate.valid 15
        and computed = run_validator validator 15 in
        let () = same (Testable.validate int) ~expected ~computed in
        let expected =
          Error.(
            to_validate @@ validation_invalid_predicate ~with_message:">100")
        and computed = run_validator validator 10 in
        let () = same (Testable.validate int) ~expected ~computed in
        let expected =
          Error.(
            to_validate @@ validation_invalid_predicate ~with_message:">100")
        and computed = run_validator validator 21 in
        let () = same (Testable.validate int) ~expected ~computed in
        let expected =
          Error.(
            to_validate @@ validation_invalid_predicate ~with_message:">100")
        and computed = run_validator validator 21 in
        let () = same (Testable.validate int) ~expected ~computed in
        let expected = Validate.valid 101
        and computed = run_validator validator 101 in
        let () = same (Testable.validate int) ~expected ~computed in
        ())
    ; test
        ~about:"a complete formlet"
        ~desc:"test over a complete formlet"
        (fun () ->
        let open Lib_form in
        let computed =
          run
            user_form
            [ "id", "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"
            ; "email", "xavier@mail.com"
            ; "checked_rules", "true"
            ]
        and expected =
          Ok
            (Individual.make
               "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"
               None
               None
               "xavier@mail.com")
        in
        same (Testable.try_ Individual.testable) ~expected ~computed)
    ; test
        ~about:"a complete formlet with missing data"
        ~desc:"test over a complete formlet with missing data"
        (fun () ->
        let open Lib_form in
        let computed = run user_form []
        and expected =
          Try.error
            Error.(
              Invalid_form
                { name = "form"
                ; errors =
                    nel
                      (Field (Missing { name = "id" }))
                      [ Field (Missing { name = "email" })
                      ; Field (Missing { name = "checked_rules" })
                      ]
                })
        in
        same (Testable.try_ Individual.testable) ~expected ~computed)
    ; test
        ~about:"a complete formlet with missing data 2"
        ~desc:"test over a complete formlet with missing data 2"
        (fun () ->
        let open Lib_form in
        let computed =
          run
            user_form
            [ "an_id", "grm"
            ; "an_email", "pierre@mail.com"
            ; "age", "-12"
            ; "name", "   "
            ]
        and expected =
          Try.error
            Error.(
              Invalid_form
                { name = "form"
                ; errors =
                    nel
                      (Field (Missing { name = "id" }))
                      [ Field
                          (Invalid
                             { name = "age"
                             ; errors =
                                 nel
                                   (Validation
                                      (Is_smaller_than
                                         { min_bound = 6; given_value = -12 }))
                                   []
                             })
                      ; Field
                          (Invalid
                             { name = "name"
                             ; errors = nel (Validation Is_blank) []
                             })
                      ; Field (Missing { name = "email" })
                      ; Field (Missing { name = "checked_rules" })
                      ]
                })
        in
        same (Testable.try_ Individual.testable) ~expected ~computed)
    ] )
;;

let suites = [ validator_cases ]
let () = Alcotest.run "Lib_form" suites
