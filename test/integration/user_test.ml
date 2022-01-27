open Lib_common
open Lib_test
open Alcotest

let test_ensure_there_is_no_user_at_starting =
  integration_test
    ~about:"count"
    ~desc:"when there is no user, it should return 0"
    (fun _env pool -> Lib_model.User.count pool)
    (fun computed ->
      let expected = 0 in
      same int ~expected ~computed)
;;

let test_try_to_add_users =
  integration_test
    ~about:"create_presaved"
    ~desc:"after creating and saving users, it should return a postive int"
    (fun _env pool ->
      let open Lwt_util in
      let*? user =
        Lwt.return
        @@ User.create_pre_saved "xvw" "xvw@github.com" "foobarfoo" "foobarfoo"
      in
      let*? () = Lib_model.User.Pre_saved.save pool user in
      let*? user =
        Lwt.return
        @@ User.create_pre_saved
             "xvw2"
             "xvw@github.com2"
             "foobarfoo"
             "foobarfoo"
      in
      let*? () = Lib_model.User.Pre_saved.save pool user in
      Lib_model.User.count pool)
    (fun computed ->
      let expected = 2 in
      same int ~expected ~computed)
;;

let cases =
  "User", [ test_ensure_there_is_no_user_at_starting; test_try_to_add_users ]
;;
