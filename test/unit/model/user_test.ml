open Lib_test
open Lib_common
open Lib_crypto
open Alcotest

let test_user_valid =
  test
    ~about:"User.For_registration validation"
    ~desc:
      "When everything is good, it should wrap a pre-saved user into an Ok \
       result"
    (fun () ->
      let computed =
        let open Try in
        let+ user =
          user_for_registration
            "xvw"
            "xavier@mail.com"
            "foobarfoobar"
            "foobarfoobar"
        in
        user.user_name, user.user_email, user.user_password
      and expected =
        Ok
          ( "xvw"
          , "xavier@mail.com"
          , Sha256.(
              hash_string "xavier@mail.com" <|> hash_string "foobarfoobar") )
      in
      same
        (Testable.try_ (triple string string Testable.sha256))
        ~expected
        ~computed)
;;

let test_user_invalid_because_confirm =
  test
    ~about:"User.For_registration validation"
    ~desc:"When there is errors it should wrap it into an error"
    (fun () ->
      let computed =
        let open Try in
        let+ user =
          user_for_registration
            "xvw"
            "xavier@mail.com"
            "foobarfoobar"
            "foobarfobar"
        in
        user.user_name, user.user_email, user.user_password
      and expected =
        Error.(
          to_try
            (invalid_object
               ~name:"User.For_registration"
               ~errors:
                 (nel
                    (field_invalid
                       ~name:"user_password"
                       ~errors:
                         (nel
                            (validation_invalid_predicate
                               ~with_message:
                                 "fields \"user_password\" and \
                                  \"confirm_user_password\" are not equivalent")
                            []))
                    [])))
      in
      same
        (Testable.try_ (triple string string Testable.sha256))
        ~expected
        ~computed)
;;

let test_user_invalid_because_confirm_and_email =
  test
    ~about:"User.For_registration validation"
    ~desc:"When there is errors, it should wrap it into an error"
    (fun () ->
      let computed =
        let open Try in
        let+ user =
          user_for_registration "xvw" "xaviermail.com" "foobarfoobar" "foooobar"
        in
        user.user_name, user.user_email, user.user_password
      and expected =
        let open Error in
        let predicate_pass =
          validation_invalid_predicate
            ~with_message:
              "fields \"user_password\" and \"confirm_user_password\" are not \
               equivalent"
        and predicate_email =
          validation_invalid_predicate
            ~with_message:
              "\"xaviermail.com\" does not appear to be an email address"
        in
        let invalid_password =
          field_invalid ~name:"user_password" ~errors:(nel predicate_pass [])
        and invalid_email =
          field_invalid ~name:"user_email" ~errors:(nel predicate_email [])
        in
        let errors = nel invalid_email [ invalid_password ] in
        to_try @@ invalid_object ~name:"User.For_registration" ~errors
      in
      same
        (Testable.try_ (triple string string Testable.sha256))
        ~expected
        ~computed)
;;

let cases =
  ( "User"
  , [ test_user_valid
    ; test_user_invalid_because_confirm
    ; test_user_invalid_because_confirm_and_email
    ] )
;;
