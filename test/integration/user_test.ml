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
      same (Testable.try_ int) ~expected ~computed)
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
      same (Testable.try_ int) ~expected ~computed)
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
      same (Testable.try_ unit) ~expected ~computed)
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
      same (Testable.try_ unit) ~expected ~computed)
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
      same (Testable.try_ unit) ~expected ~computed)
;;

let test_get_for_connection_when_there_is_no_user =
  integration_test
    ~about:"get_for_connection"
    ~desc:"when there is no user, it should raise an error"
    (fun _ db ->
      let open Lwt_util in
      let email = "pierre@mail.com"
      and password = "password_of_pierre" in
      let*? obj = return @@ user_for_connection email password in
      Model.User.Saved.get_for_connection obj db)
    (fun computed ->
      let expected = Error.(to_try @@ user_not_found "pierre@mail.com") in
      same (Testable.try_ Testable.saved_user) ~expected ~computed)
;;

let test_get_for_connection_when_there_is_no_candidate_user =
  integration_test
    ~about:"get_for_connection"
    ~desc:"when there is no associated user, it should raise an error"
    (fun _ db ->
      let open Lwt_util in
      let*? _ = make_user "user_1" "x@g.com" "1234567" db in
      let*? _ = make_user "user_2" "q@g.com" "1234567" db in
      let email = "pierre@mail.com"
      and password = "password_of_pierre" in
      let*? obj = return @@ user_for_connection email password in
      Model.User.Saved.get_for_connection obj db)
    (fun computed ->
      let expected = Error.(to_try @@ user_not_found "pierre@mail.com") in
      same (Testable.try_ Testable.saved_user) ~expected ~computed)
;;

let test_get_for_connection_when_there_is_no_candidate_user_because_of_password =
  integration_test
    ~about:"get_for_connection"
    ~desc:
      "when there is no associated user because of password, it should raise \
       an error"
    (fun _ db ->
      let open Lwt_util in
      let*? _ = make_user "user_1" "x@g.com" "1234567" db in
      let*? _ = make_user "user_2" "q@g.com" "1234567" db in
      let email = "x@g.com"
      and password = "password_of_pierre" in
      let*? obj = return @@ user_for_connection email password in
      Model.User.Saved.get_for_connection obj db)
    (fun computed ->
      let expected = Error.(to_try @@ user_not_found "x@g.com") in
      same (Testable.try_ Testable.saved_user) ~expected ~computed)
;;

let test_get_for_connection_when_there_is_no_candidate_user_because_of_activate =
  integration_test
    ~about:"get_for_connection"
    ~desc:"when there is no activated associated user, it should raise an error"
    (fun _ db ->
      let open Lwt_util in
      let*? _ = make_user "user_1" "x@g.com" "1234567" db in
      let*? _ = make_user "user_2" "q@g.com" "1234567" db in
      let email = "x@g.com"
      and password = "1234567" in
      let*? obj = return @@ user_for_connection email password in
      Model.User.Saved.get_for_connection obj db)
    (fun computed ->
      let expected = Error.(to_try @@ user_not_activated "x@g.com") in
      same (Testable.try_ Testable.saved_user) ~expected ~computed)
;;

let test_get_for_connection_when_there_is_a_candidate_user =
  integration_test
    ~about:"get_for_connection"
    ~desc:"when there is an associated user, it should returns it"
    (fun _ db ->
      let open Lwt_util in
      let state = Model.User.State.Member in
      let*? witness_user = make_user ~state "user_1" "x@g.com" "1234567" db in
      let*? _ = make_user "user_2" "q@g.com" "1234567" db in
      let email = "x@g.com"
      and password = "1234567" in
      let*? obj = return @@ user_for_connection email password in
      let+? computed = Model.User.Saved.get_for_connection obj db in
      computed, witness_user)
    (function
      | Error _ -> assert false
      | Ok (computed, expected) -> same Testable.saved_user ~expected ~computed)
;;

let test_list_active_when_no_user =
  integration_test
    ~about:"list_active"
    ~desc:"when there is no stored user it should returns an empty list"
    (fun _ db ->
      let open Model.User in
      Saved.(list_active (fun u -> u.user_email) db))
    (fun computed ->
      let expected = Ok [] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_list_active_when_no_activated_user =
  integration_test
    ~about:"list_active"
    ~desc:"when there is no activated user it should returns an empty list"
    (fun _ db ->
      let open Model.User in
      let open Lwt_util in
      let*? _ = make_user "user_1" "x@g.com" "1234567" db in
      let*? _ = make_user "user_2" "q@g.com" "1234567" db in
      Saved.(list_active (fun u -> u.user_email) db))
    (fun computed ->
      let expected = Ok [] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_list_active_when_there_are_candidates =
  integration_test
    ~about:"list_active"
    ~desc:"when there are activated users it should returns it"
    (fun _ db ->
      let open Model.User in
      let open Lwt_util in
      let*? _ = make_user ~state:State.Member "user_1" "a@g.com" "1234567" db in
      let*? _ = make_user ~state:State.Member "user_2" "b@g.com" "1234567" db in
      let*? _ = make_user "user_3" "c@g.com" "1111111" db in
      let*? _ = make_user ~state:State.Admin "user_4" "d@g.com" "11111111" db in
      let*? _ =
        make_user ~state:State.Moderator "user_5" "e@g.com" "1111111" db
      in
      Saved.(list_active ~like:"user_%" (fun u -> u.user_name) db))
    (fun computed ->
      let expected = Ok [ "user_1"; "user_2"; "user_4"; "user_5" ] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_list_active_when_there_are_candidates_with_like =
  integration_test
    ~about:"list_active"
    ~desc:
      "when there are activated users it should returns the one that fit with \
       like"
    (fun _ db ->
      let open Model.User in
      let open Lwt_util in
      let*? _ = make_user ~state:State.Member "user_1" "a@g.com" "1234567" db in
      let*? _ =
        make_user ~state:State.Member "grm" "user_@g.com" "1234567" db
      in
      let*? _ = make_user "user_3" "c@g.com" "1111111" db in
      let*? _ = make_user ~state:State.Admin "user_4" "d@g.com" "11111111" db in
      let*? _ =
        make_user ~state:State.Moderator "fooo" "e@g.com" "1111111" db
      in
      Saved.(list_active ~like:"user_%" (fun u -> u.user_name) db))
    (fun computed ->
      let expected = Ok [ "user_1"; "grm"; "user_4" ] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let cases =
  ( "User"
  , [ test_ensure_there_is_no_user_at_starting
    ; test_try_to_add_users
    ; test_add_user_with_username_and_email_not_free
    ; test_add_user_with_username_not_free
    ; test_add_user_with_email_not_free
    ; test_get_for_connection_when_there_is_no_user
    ; test_get_for_connection_when_there_is_no_candidate_user
    ; test_get_for_connection_when_there_is_no_candidate_user_because_of_password
    ; test_get_for_connection_when_there_is_no_candidate_user_because_of_activate
    ; test_get_for_connection_when_there_is_a_candidate_user
    ; test_list_active_when_no_user
    ; test_list_active_when_no_activated_user
    ; test_list_active_when_there_are_candidates
    ; test_list_active_when_there_are_candidates_with_like
    ] )
;;
