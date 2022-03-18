open Lib_common
open Lib_test
open Alcotest

let test_ensure_there_is_no_user_at_starting =
  integration_test
    ~about:"count"
    ~desc:"when there is no user, it should return 0"
    (fun _env db -> Model.User.Saved.count db)
    (fun computed ->
      let expected = Ok 0 in
      same (try_testable int) ~expected ~computed)
;;

let test_try_to_add_users =
  integration_test
    ~about:"create_for_registration"
    ~desc:"after creating and saving users, it should return a postive int"
    (fun _env db ->
      let open Lwt_util in
      let*? user =
        Lwt.return
        @@ user_for_registration "xvw" "xvw@github.com" "foobarfoo" "foobarfoo"
      in
      let*? () = Model.User.For_registration.save user db in
      let*? user =
        Lwt.return
        @@ user_for_registration
             "xvw2"
             "xvw@github.com2"
             "foobarfoo"
             "foobarfoo"
      in
      let*? () = Model.User.For_registration.save user db in
      Model.User.Saved.count db)
    (fun computed ->
      let expected = Ok 2 in
      same (try_testable int) ~expected ~computed)
;;

let test_add_user_with_username_and_email_not_free =
  integration_test
    ~about:"save_for_registration"
    ~desc:
      "when an username and an email are already taken, it should return an \
       error"
    (fun _env db ->
      let open Lwt_util in
      let*? u =
        return (user_for_registration "xvw" "x@g.com" "1234567" "1234567")
      in
      let*? () = Model.User.For_registration.save u db in
      let*? u =
        return (user_for_registration "xvw" "x@g.com" "1234567" "1234567")
      in
      Model.User.For_registration.save u db)
    (fun computed ->
      let expected =
        Error.(to_try @@ user_already_taken ~username:"xvw" ~email:"x@g.com")
      in
      same (try_testable unit) ~expected ~computed)
;;

let test_add_user_with_username_not_free =
  integration_test
    ~about:"save_for_registration"
    ~desc:"when an username is already taken, it should return an error"
    (fun _env db ->
      let open Lwt_util in
      let*? u =
        return (user_for_registration "xvw" "x@g.com" "1234567" "1234567")
      in
      let*? () = Model.User.For_registration.save u db in
      let*? u =
        return (user_for_registration "xvw" "q@g.com" "1234567" "1234567")
      in
      Model.User.For_registration.save u db)
    (fun computed ->
      let expected = Error.(to_try @@ user_name_already_taken "xvw") in
      same (try_testable unit) ~expected ~computed)
;;

let test_add_user_with_email_not_free =
  integration_test
    ~about:"save_for_registration"
    ~desc:"when an email is already taken, it should return an error"
    (fun _env db ->
      let open Lwt_util in
      let*? u =
        return (user_for_registration "x" "q@g.com" "1234567" "1234567")
      in
      let*? () = Model.User.For_registration.save u db in
      let*? u =
        return (user_for_registration "xvw" "q@g.com" "1234567" "1234567")
      in
      Model.User.For_registration.save u db)
    (fun computed ->
      let expected = Error.(to_try @@ user_email_already_taken "q@g.com") in
      same (try_testable unit) ~expected ~computed)
;;

let cases =
  ( "User"
  , [ test_ensure_there_is_no_user_at_starting
    ; test_try_to_add_users
    ; test_add_user_with_username_and_email_not_free
    ; test_add_user_with_username_not_free
    ; test_add_user_with_email_not_free
    ] )
;;
