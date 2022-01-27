open Lib_test
open Lib_common
open Lib_crypto
open Alcotest

let test_user_valid =
  let open Lib_model.User.Pre_saved in
  test
    ~about:"Pre_saved.create"
    ~desc:
      "When everything is good, it should wrap a pre-saved user into an Ok \
       result"
    (fun () ->
      let computed =
        let open Try in
        let+ user =
          User.create_pre_saved
            "xvw"
            "xavier@mail.com"
            "foobarfoobar"
            "foobarfoobar"
        in
        user.user_name, user.user_email, user.user_password
      and expected =
        Ok ("xvw", "xavier@mail.com", Sha256.hash_string "foobarfoobar")
      in
      same
        (try_testable (triple string string sha256_testable))
        ~expected
        ~computed)
;;

let test_user_invalid_because_confirm =
  let open Lib_model.User.Pre_saved in
  test
    ~about:"Pre_saved.create"
    ~desc:
      "When everything is good, it should wrap a pre-saved user into an Ok \
       result"
    (fun () ->
      let computed =
        let open Try in
        let+ user =
          User.create_pre_saved
            "xvw"
            "xavier@mail.com"
            "foobarfoobar"
            "foobarfobar"
        in
        user.user_name, user.user_email, user.user_password
      and expected =
        Error.(
          to_try
            (Invalid_provider
               { provider = "User.Pre_saved"
               ; errors =
                   nel
                     (Invalid_field
                        { key = "user_password"
                        ; errors =
                            nel
                              (Invalid_predicate
                                 "fields \"user_password\" and \
                                  \"confirm_user_password\" are not equivalent")
                              []
                        })
                     []
               }))
      in
      same
        (try_testable (triple string string sha256_testable))
        ~expected
        ~computed)
;;

let test_user_invalid_because_confirm_and_email =
  let open Lib_model.User.Pre_saved in
  test
    ~about:"Pre_saved.create"
    ~desc:
      "When everything is good, it should wrap a pre-saved user into an Ok \
       result"
    (fun () ->
      let computed =
        let open Try in
        let+ user =
          User.create_pre_saved "xvw" "xaviermail.com" "foobarfoobar" "foooobar"
        in
        user.user_name, user.user_email, user.user_password
      and expected =
        Error.(
          to_try
            (Invalid_provider
               { provider = "User.Pre_saved"
               ; errors =
                   nel
                     (Invalid_field
                        { key = "user_email"
                        ; errors =
                            nel
                              (Invalid_predicate
                                 "\"xaviermail.com\" does not appear to be an \
                                  email address")
                              []
                        })
                     [ Invalid_field
                         { key = "user_password"
                         ; errors =
                             nel
                               (Invalid_predicate
                                  "fields \"user_password\" and \
                                   \"confirm_user_password\" are not \
                                   equivalent")
                               []
                         }
                     ]
               }))
      in
      same
        (try_testable (triple string string sha256_testable))
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
