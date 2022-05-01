open Alcotest
open Lib_test
open Lib_service

let meth_eq =
  let pp ppf = function
    | `Post -> Format.fprintf ppf "Post"
    | `Get -> Format.fprintf ppf "Get"
    | _ -> Format.fprintf ppf "Unknown"
  and equal a b =
    match a, b with
    | `Post, `Post -> true
    | `Get, `Get -> true
    | _, _ -> false
  in
  Alcotest.testable pp equal
;;

let hello_world () =
  let open Endpoint in
  get (~/"hello" / "world")
;;

let hello () =
  let open Endpoint in
  get (~/"hello" /: string)
;;

let complicated_one () =
  let open Endpoint in
  post
    (~/"user"
    / "new"
    / "name"
    /: string
    / "age"
    /: int
    / "a_char"
    /: char
    / "is_active"
    /: bool
    / "email"
    /: string)
;;

let test_handle_link =
  test
    ~about:"handle_link"
    ~desc:"ensure that link handling are properly generated"
  @@ fun () ->
  let expected =
    [ "/hello/world"
    ; "/hello/Antoine"
    ; "/user/new/name/Antoine/age/77/a_char/X/is_active/true/email/the_xhtmlboiz@4chan.com"
    ]
  and computed =
    Endpoint.
      [ handle_link ~:hello_world Fun.id
      ; handle_link ~:hello Fun.id "Antoine"
      ; handle_link
          ~:complicated_one
          Fun.id
          "Antoine"
          77
          'X'
          true
          "the_xhtmlboiz@4chan.com"
      ]
  in
  same (list string) ~expected ~computed
;;

let test_href_link =
  test ~about:"href" ~desc:"ensure that link href are properly generated"
  @@ fun () ->
  let expected = [ "/hello/world"; "/hello/Antoine" ]
  and computed = Endpoint.[ href ~:hello_world; href ~:hello "Antoine" ] in
  same (list string) ~expected ~computed
;;

let test_form_action_method_link =
  test ~about:"href" ~desc:"ensure that link href are properly generated"
  @@ fun () ->
  let expected =
    [ `Get, "/hello/world"
    ; `Get, "/hello/Antoine"
    ; ( `Post
      , "/user/new/name/Antoine/age/77/a_char/X/is_active/true/email/the_xhtmlboiz@4chan.com"
      )
    ]
  and computed =
    Endpoint.
      [ form_method_action ~:hello_world
      ; form_method_action ~:hello "Antoine"
      ; form_method_action
          ~:complicated_one
          "Antoine"
          77
          'X'
          true
          "the_xhtmlboiz@4chan.com"
      ]
  in
  same (list (pair meth_eq string)) ~expected ~computed
;;

let cases =
  "Endpoint", [ test_handle_link; test_href_link; test_form_action_method_link ]
;;
