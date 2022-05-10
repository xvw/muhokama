open Lib_common
open Lib_test
open Alcotest

let test_ensure_there_is_no_category_at_starting =
  integration_test
    ~about:"count"
    ~desc:"when there is no category, it should return 0"
    (fun _env db -> Models.Category.count db)
    (fun computed ->
      let expected = Ok 0 in
      same (Testable.try_ int) ~expected ~computed)
;;

let test_try_to_add_category =
  integration_test
    ~about:"for_creation"
    ~desc:"when there is no conflict, a category should be inserted"
    (fun _env db ->
      let open Lwt_util in
      let*? category =
        Lwt.return
        @@ category_for_creation "general" "a category for general purpose"
      in
      let*? () = Models.Category.create category db in
      let*? category =
        Lwt.return
        @@ category_for_creation
             "Programming   "
             "a category for programming stuff"
      in
      let*? () = Models.Category.create category db in
      let*? count = Models.Category.count db in
      let+? list = Models.Category.(list (fun { name; _ } -> name) db) in
      count, list)
    (fun computed ->
      let expected = Ok (2, [ "general"; "programming" ]) in
      same (Testable.try_ (pair int (list string))) ~expected ~computed)
;;

let test_category_unicity =
  integration_test
    ~about:"for_creation"
    ~desc:"when there is conflict, it should return an error"
    (fun _env db ->
      let open Lwt_util in
      let*? category =
        Lwt.return
        @@ category_for_creation "general" "a category for general purpose"
      in
      let*? () = Models.Category.create category db in
      let*? category =
        Lwt.return
        @@ category_for_creation "General   " "a category for programming stuff"
      in
      Models.Category.create category db)
    (fun computed ->
      let expected = Error.(to_try @@ category_name_already_taken "general") in
      same (Testable.try_ unit) ~expected ~computed)
;;

let cases =
  ( "Category"
  , [ test_ensure_there_is_no_category_at_starting
    ; test_try_to_add_category
    ; test_category_unicity
    ] )
;;
