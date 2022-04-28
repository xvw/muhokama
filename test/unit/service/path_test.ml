open Alcotest
open Lib_test
open Lib_service

let test_to_route_for_a_constant_path =
  test
    ~about:"to_route"
    ~desc:
      "when it doesn't introduce any variables, it should return a route \
       without parameters"
    (fun () ->
      let path = Path.(!"YOCaml" / "is" / "beautiful") in
      let expected = "/YOCaml/is/beautiful"
      and computed = Path.to_route path in
      same string ~expected ~computed)
;;

let test_to_route_for_a_path_with_params =
  test
    ~about:"to_route"
    ~desc:
      "when the path introduces variables, it should return a route with \
       parameters"
    (fun () ->
      let path = Path.(!"by" / "id" /: string / "and_age" /: int) in
      let expected = "/by/id/:string_1/and_age/:int_2"
      and computed = Path.to_route path in
      same string ~expected ~computed)
;;

let test_to_string_for_a_constant_path =
  test
    ~about:"to_string"
    ~desc:"when it doesn't introduce any variable, the continuation is a value"
    (fun () ->
      let path = Path.(!"YOCaml" / "is" / "beautiful") in
      let expected = "/YOCaml/is/beautiful"
      and computed = Path.to_string path in
      same string ~expected ~computed)
;;

let test_to_string_for_a_path_with_params =
  test
    ~about:"to_route"
    ~desc:
      "when the path introduces variables, the continuation is a function that \
       takes parameters"
    (fun () ->
      let path = Path.(!"by" / "id" /: string / "and_age" /: int) in
      let expected = "/by/id/Antoine/and_age/77"
      and computed = Path.to_string path "Antoine" 77 in
      same string ~expected ~computed)
;;

module M = Map.Make (String)

let test_handle_for_path_without_params =
  test
    ~about:"handle"
    ~desc:
      "When the path doesn't introduce any variable, the continuation is a \
       value"
    (fun () ->
      let path = Path.(!"YOCaml" / "is" / "beautiful")
      and get x = M.find x M.empty in
      let expected = "Yes, definitely"
      and computed = Path.handle get path "Yes, definitely" in
      same string ~expected ~computed)
;;

let test_handle_for_path_with_params =
  test
    ~about:"handle"
    ~desc:
      "when the path introduces variables, the continuation is a function that \
       takes parameters"
    (fun () ->
      let path = Path.(!"by" / "id" /: string / "and_age" /: int)
      and map = M.empty |> M.add "string_1" "Antoine" |> M.add "int_2" "77" in
      let get x = M.find x map in
      let expected = "Name: Antoine, Age: 77"
      and computed =
        Path.handle get path (fun name age ->
            Format.asprintf "Name: %s, Age: %d" name age)
      in
      same string ~expected ~computed)
;;

let test_handle_with_for_path_with_params =
  test
    ~about:"handle_with"
    ~desc:
      "when the path introduces variables, the continuation is a function that \
       takes parameters"
    (fun () ->
      let path = Path.(!"by" / "id" /: string / "and_age" /: int) in
      let expected = Some "Name: Antoine, Age: 77"
      and computed =
        Path.handle_with "by/id/Antoine/and_age/77" path
        @@ Format.asprintf "Name: %s, Age: %d"
      in
      same (option string) ~expected ~computed)
;;

let test_handle_with_for_path_with_params_when_invalid_uri =
  test
    ~about:"handle_with"
    ~desc:
      "when the path introduces variables, the continuation is a function that \
       takes parameters, if the path is not valid, it should returns None"
    (fun () ->
      let path = Path.(!"by" / "id" /: string / "and_age" /: int) in
      let expected = None
      and computed =
        Path.handle_with "by/id/Antoine/and_age/test" path
        @@ Format.asprintf "Name: %s, Age: %d"
      in
      same (option string) ~expected ~computed)
;;

let test_handle_with_for_path_without_params =
  test
    ~about:"handle_with"
    ~desc:
      "When the path doesn't introduce any variable, the continuation is a \
       value"
    (fun () ->
      let path = Path.(!"YOCaml" / "is" / "beautiful") in
      let expected = Some "Yes, definitely"
      and computed =
        Path.handle_with "YOCaml/is/beautiful" path "Yes, definitely"
      in
      same (option string) ~expected ~computed)
;;

let test_handle_with_for_path_without_params_with_invalid_uri =
  test
    ~about:"handle_with"
    ~desc:
      "When the path doesn't introduce any variable, the continuation is a \
       value"
    (fun () ->
      let path = Path.(!"YOCaml" / "is" / "beautiful") in
      let expected = None
      and computed =
        Path.handle_with "YOCaml/is-not/beautiful" path "Yes, definitely"
      in
      same (option string) ~expected ~computed)
;;

let cases =
  ( "Service.Path"
  , [ test_to_route_for_a_constant_path
    ; test_to_route_for_a_path_with_params
    ; test_to_string_for_a_constant_path
    ; test_to_string_for_a_path_with_params
    ; test_handle_for_path_without_params
    ; test_handle_for_path_with_params
    ; test_handle_with_for_path_with_params
    ; test_handle_with_for_path_with_params_when_invalid_uri
    ; test_handle_with_for_path_without_params
    ; test_handle_with_for_path_without_params_with_invalid_uri
    ] )
;;
