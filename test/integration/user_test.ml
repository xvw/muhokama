open Lib_common
open Lib_test
open Alcotest

let test_ensure_there_is_no_user_at_starting =
  integration_test
    ~about:"count"
    ~desc:"it should return 0"
    (fun _env pool ->
      let open Lwt_util in
      let+? i = Lib_model.User.count pool in
      pool, i)
    (fun computed ->
      let expected = 0 in
      same int ~expected ~computed)
;;

let cases = "User", [ test_ensure_there_is_no_user_at_starting ]
