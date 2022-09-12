open Alcotest
open Lib_test
open Lib_service

let test_sanitize_path_with_empty_uri =
  test
    ~about:"sanitize_path"
    ~desc:"when the path is empty, it should return an empty list"
    (fun () ->
    let path = "" in
    let expected = []
    and computed = Helper.sanitize_path path in
    same (list string) ~expected ~computed)
;;

let test_sanitize_path_with_root =
  test
    ~about:"sanitize_path"
    ~desc:"when the path is the root, it should return an empty list"
    (fun () ->
    let path = "/" in
    let expected = []
    and computed = Helper.sanitize_path path in
    same (list string) ~expected ~computed)
;;

let test_sanitize_path_with_only_get_things =
  test
    ~about:"sanitize_path"
    ~desc:
      "when the path is only filled by GET args, it should return an empty list"
    (fun () ->
    let path = "?foo=thing" in
    let expected = []
    and computed = Helper.sanitize_path path in
    same (list string) ~expected ~computed)
;;

let test_sanitize_path_with_valid_uri =
  test
    ~about:"sanitize_path"
    ~desc:"when the path has fragment, it should extract it"
    (fun () ->
    let path = "foo/bar/10/" in
    let expected = [ "foo"; "bar"; "10"; "" ]
    and computed = Helper.sanitize_path path in
    same (list string) ~expected ~computed)
;;

let test_sanitize_path_with_valid_uri_and_get_things =
  test
    ~about:"sanitize_path"
    ~desc:
      "when the path has fragment and GET args, it should extract fragments \
       and discard GET args"
    (fun () ->
    let path = "foo/bar/10?foo=bar" in
    let expected = [ "foo"; "bar"; "10" ]
    and computed = Helper.sanitize_path path in
    same (list string) ~expected ~computed)
;;

let cases =
  ( "Helper"
  , [ test_sanitize_path_with_empty_uri
    ; test_sanitize_path_with_root
    ; test_sanitize_path_with_only_get_things
    ; test_sanitize_path_with_valid_uri
    ; test_sanitize_path_with_valid_uri_and_get_things
    ] )
;;
