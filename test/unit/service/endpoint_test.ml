open Alcotest
open Lib_test
open Lib_service
module E = Endpoint
module P = Path

let method_to_string = function
  | `Get -> "Get"
  | `Post -> "Post"
;;

let hello_world () =
  E.get
    (Fun.const P.(!"hello" / "world"))
    [ (fun handler request ->
        if request = "foo" then "bar" else handler request)
    ]
    ()
;;

let hello_to () = E.post (Fun.const P.(!"hello" /: string)) [] ()

let router =
  E.
    [ route (hello_world ()) (fun _request -> "Hello World!")
    ; route (hello_to ()) (fun nickname _request -> "Hello " ^ nickname)
    ]
;;

let test_service_method_get =
  test ~about:"method" ~desc:"A GET service should have `Get method" (fun () ->
      let expected = "Get"
      and computed = E.method_ (hello_world ()) |> method_to_string in
      same string ~expected ~computed)
;;

let test_service_method_post =
  test
    ~about:"method"
    ~desc:"A POST service should have `Post method"
    (fun () ->
      let expected = "Post"
      and computed = E.method_ (hello_to ()) |> method_to_string in
      same string ~expected ~computed)
;;

let test_decide_1 =
  test ~about:"decide" ~desc:"decide scenario 1" (fun () ->
      let expected = "Hello World!"
      and computed = E.decide router `GET "hello/world" (fun _ -> "404") "" in
      same string ~expected ~computed)
;;

let test_decide_2 =
  test ~about:"decide" ~desc:"decide scenario 2" (fun () ->
      let expected = "404"
      and computed = E.decide router `GET "hello/worldz" (fun _ -> "404") "" in
      same string ~expected ~computed)
;;

let test_decide_3 =
  test ~about:"decide" ~desc:"decide scenario 3" (fun () ->
      let expected = "Hello Antoine"
      and computed =
        E.decide router `POST "hello/Antoine" (fun _ -> "404") ""
      in
      same string ~expected ~computed)
;;

let test_decide_4 =
  test ~about:"decide" ~desc:"decide scenario 4" (fun () ->
      let expected = "bar"
      and computed =
        E.decide router `GET "hello/world" (fun _ -> "404") "foo"
      in
      same string ~expected ~computed)
;;

let cases =
  ( "Service.Endpoint"
  , [ test_service_method_get
    ; test_service_method_post
    ; test_decide_1
    ; test_decide_2
    ; test_decide_3
    ; test_decide_4
    ] )
;;
