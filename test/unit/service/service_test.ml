open Alcotest
open Lib_test
open Lib_service
module MS = Map.Make (String)

module P = struct
  type t =
    { request : string MS.t
    ; status : int
    ; content : string
    }

  let equal
      { request = r_a; content = c_a; status = s_a }
      { request = r_b; content = c_b; status = s_b }
    =
    MS.equal String.equal r_a r_b && String.equal c_a c_b && Int.equal s_a s_b
  ;;

  let pp ppf { request; content; status } =
    Format.fprintf
      ppf
      "{request = %a; content = %s; status = %d}"
      Preface.(
        Format.pp_print_seq
          (Pair.pp Format.pp_print_text Format.pp_print_string))
      (MS.to_seq request)
      content
      status
  ;;

  let testable = testable pp equal
end

module E = struct
  open Endpoint

  let hello_world () = get (~/"hello" / "world")
  let hello_to () = post (~/"hello" /: string)
  let leave () = get ~/"leave"
  let show () = get (~/"show" / "name" /: string / "age" /: int)
end

let error_404 content request = Lwt.return P.{ request; status = 404; content }

module M = struct
  let discard_page message p inner request =
    if p request then error_404 message request else inner request
  ;;

  let add_variable key value inner request =
    let new_request = MS.add key value request in
    inner new_request
  ;;

  let provide_nickname inner request =
    let nickname = MS.find_opt "nickname" request in
    discard_page
      "Variable nickname does not exists"
      (fun _ -> Option.is_none nickname)
      (inner @@ Option.value ~default:"XHTMLBoy" nickname)
      request
  ;;
end

module S = struct
  let hello_world =
    Service.straight
      ~:E.hello_world
      M.
        [ add_variable "hello" "world"
        ; add_variable "foo" "bar"
        ; add_variable "muho" "kama"
        ]
      (fun request ->
        let content = "Hello, World!" in
        Lwt.return P.{ request; content; status = 200 })
  ;;

  let hello_to =
    Service.straight_with
      ~attached:M.provide_nickname
      ~:E.hello_to
      []
      (fun name nickname request ->
        let content = Format.asprintf "Hello, %s! (%s)" name nickname in
        Lwt.return P.{ request; content; status = 200 })
  ;;

  let leave =
    Service.straight_with
      ~attached:M.provide_nickname
      ~:E.leave
      []
      (fun nickname request ->
        let content = Format.asprintf "Goodbye, %s!" nickname in
        Lwt.return P.{ request; content; status = 200 })
  ;;

  let show =
    let succeed (name, age) request =
      let content = Format.asprintf "name: %s, age: %d" name age in
      Lwt.return P.{ request; content; status = 200 }
    and failure message request =
      let content = Format.asprintf "error: %s" message in
      Lwt.return P.{ request; content; status = 500 }
    in
    Service.failable_with
      ~attached:M.provide_nickname
      ~:E.show
      []
      ~succeed
      ~failure
      (fun name age nickname _request ->
        Lwt.return
          (if String.equal name String.empty
          then Error "name too short"
          else if String.equal nickname String.empty
          then Error "nickname too short"
          else if age < 0
          then Error "age too low"
          else Ok (name, age)))
  ;;
end

let make_request list = MS.of_seq @@ List.to_seq list

let choose method_ uri inner request =
  Service.choose
    method_
    uri
    S.[ hello_world; hello_to; leave; show ]
    inner
    request
;;

let test_choose_hello_world =
  test
    ~about:"choose"
    ~desc:"when [S.hello_world] is choosable, it should apply the service"
  @@ fun () ->
  let method_ = `GET
  and uri = "/hello/world"
  and request = make_request [ "hello", "world"; "foo", "bar"; "muho", "kama" ]
  and content = "Hello, World!"
  and status = 200 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run @@ choose method_ uri (error_404 "Not found") MS.empty
  in
  same P.testable ~expected ~computed
;;

let test_choose_hello_to =
  test
    ~about:"choose"
    ~desc:"when [S.hello_to] is choosable, it should apply the service"
  @@ fun () ->
  let method_ = `POST
  and uri = "/hello/Antoine"
  and request = make_request [ "nickname", "xhtmlboi" ]
  and content = "Hello, Antoine! (xhtmlboi)"
  and status = 200 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run
    @@ choose
         method_
         uri
         (error_404 "Not found")
         (make_request [ "nickname", "xhtmlboi" ])
  in
  same P.testable ~expected ~computed
;;

let test_choose_leave =
  test
    ~about:"choose"
    ~desc:"when [S.leave] is choosable, it should apply the service"
  @@ fun () ->
  let method_ = `GET
  and uri = "/leave"
  and request = make_request [ "nickname", "xhtmlboi" ]
  and content = "Goodbye, xhtmlboi!"
  and status = 200 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run
    @@ choose
         method_
         uri
         (error_404 "Not found")
         (make_request [ "nickname", "xhtmlboi" ])
  in
  same P.testable ~expected ~computed
;;

let test_choose_show =
  test
    ~about:"choose"
    ~desc:"when [S.show] is choosable, it should apply the service"
  @@ fun () ->
  let method_ = `GET
  and uri = "/show/name/Antoine/age/77"
  and request = make_request [ "nickname", "xhtmlboi" ]
  and content = "name: Antoine, age: 77"
  and status = 200 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run
    @@ choose
         method_
         uri
         (error_404 "Not found")
         (make_request [ "nickname", "xhtmlboi" ])
  in
  same P.testable ~expected ~computed
;;

let test_choose_without_candidate =
  test
    ~about:"choose"
    ~desc:"when there is no candidate, it should raise Not found"
  @@ fun () ->
  let method_ = `GET
  and uri = "/foo/bar/baz"
  and request = make_request []
  and content = "Not found"
  and status = 404 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run @@ choose method_ uri (error_404 "Not found") MS.empty
  in
  same P.testable ~expected ~computed
;;

let test_choose_hello_to_without_nickname =
  test
    ~about:"choose"
    ~desc:
      "when [S.hello_to] is choosable, it should apply the service (and fail \
       because [nickname] is missing)"
  @@ fun () ->
  let method_ = `POST
  and uri = "/hello/Antoine"
  and request = make_request []
  and content = "Variable nickname does not exists"
  and status = 404 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run @@ choose method_ uri (error_404 "Not found") (make_request [])
  in
  same P.testable ~expected ~computed
;;

let test_choose_leave_without_nickname =
  test
    ~about:"choose"
    ~desc:
      "when [S.leave] is choosable, it should apply the service (and fail \
       because [nickname] is missing)"
  @@ fun () ->
  let method_ = `GET
  and uri = "/leave"
  and request = make_request []
  and content = "Variable nickname does not exists"
  and status = 404 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run @@ choose method_ uri (error_404 "Not found") (make_request [])
  in
  same P.testable ~expected ~computed
;;

let test_choose_show_without_nickname =
  test
    ~about:"choose"
    ~desc:
      "when [S.show] is choosable, it should apply the service (and fail \
       because [nickname] is missing)"
  @@ fun () ->
  let method_ = `GET
  and uri = "/show/name/Antoine/age/77"
  and request = make_request []
  and content = "Variable nickname does not exists"
  and status = 404 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run @@ choose method_ uri (error_404 "Not found") (make_request [])
  in
  same P.testable ~expected ~computed
;;

let test_choose_show_with_failure_on_name_invariant =
  test
    ~about:"choose"
    ~desc:
      "when [S.show] is choosable, it should apply the service and fail \
       because the name is too short)"
  @@ fun () ->
  let method_ = `GET
  and uri = "/show/name//age/0"
  and request = make_request [ "nickname", "" ]
  and content = "error: name too short"
  and status = 500 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run
    @@ choose
         method_
         uri
         (error_404 "Not found")
         (make_request [ "nickname", "" ])
  in
  same P.testable ~expected ~computed
;;

let test_choose_show_with_failure_on_nickname_invariant =
  test
    ~about:"choose"
    ~desc:
      "when [S.show] is choosable, it should apply the service and fail \
       because the nickname is too short)"
  @@ fun () ->
  let method_ = `GET
  and uri = "/show/name/Antoine/age/-77"
  and request = make_request [ "nickname", "" ]
  and content = "error: nickname too short"
  and status = 500 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run
    @@ choose
         method_
         uri
         (error_404 "Not found")
         (make_request [ "nickname", "" ])
  in
  same P.testable ~expected ~computed
;;

let test_choose_show_with_failure_on_age_invariant =
  test
    ~about:"choose"
    ~desc:
      "when [S.show] is choosable, it should apply the service and fail \
       because the age is to low)"
  @@ fun () ->
  let method_ = `GET
  and uri = "/show/name/Antoine/age/-77"
  and request = make_request [ "nickname", "xhtml" ]
  and content = "error: age too low"
  and status = 500 in
  let expected = P.{ request; content; status }
  and computed =
    Lwt_main.run
    @@ choose
         method_
         uri
         (error_404 "Not found")
         (make_request [ "nickname", "xhtml" ])
  in
  same P.testable ~expected ~computed
;;

let test_doc_straight_hello =
  test
    ~about:"straight"
    ~desc:"documentation example for straight (hello world)"
  @@ fun () ->
  let service =
    Service.straight
      Endpoint.(get (~/"hello" / "world"))
      []
      (fun _request ->
        let result = "Hello, World!" in
        Lwt.return result)
  in
  let computed =
    Lwt_main.run
      (Service.choose
         `GET
         "/hello/world"
         [ service ]
         (fun _ -> Lwt.return "error")
         None)
  and expected = "Hello, World!" in
  same string ~expected ~computed
;;

let test_doc_straight_sum =
  test ~about:"straight" ~desc:"documentation example for straight (sum)"
  @@ fun () ->
  let service =
    Service.straight
      Endpoint.(get (~/"sum" /: int /: int))
      []
      (fun x y _request ->
        let result = Format.asprintf "%d + %d = %d" x y (x + y) in
        Lwt.return result)
  in
  let computed =
    Lwt_main.run
      (Service.choose
         `GET
         "/sum/12/30"
         [ service ]
         (fun _ -> Lwt.return "error")
         None)
  and expected = "12 + 30 = 42" in
  same string ~expected ~computed
;;

let test_doc_straight_with_provide_user =
  test
    ~about:"straight_with"
    ~desc:"documentation example for straight_with (user provider)"
  @@ fun () ->
  let is_authenticated handler request =
    match MS.find_opt "user" request with
    | None -> Lwt.return "no user"
    | Some _ -> handler request
  in
  let provide_user handler request =
    match MS.find_opt "user" request with
    | None -> Lwt.return "no user"
    | Some (activated, user) ->
      if activated then handler user request else Lwt.return "not activated"
  in
  let service =
    Service.straight_with
      Endpoint.(get (~/"secret" / "area" /: string))
      [ is_authenticated ]
      ~attached:provide_user
      (fun password user _request ->
        if password = "qwerty"
        then Lwt.return @@ Format.asprintf "Welcome %s to the secret area!" user
        else Lwt.return "bad password")
  in
  let computed ?user password =
    let req =
      Option.fold
        ~none:MS.empty
        ~some:(fun x -> make_request [ "user", x ])
        user
    in
    Lwt_main.run
      (Service.choose
         `GET
         ("/secret/area/" ^ password)
         [ service ]
         (fun _ -> Lwt.return "error")
         req)
  in
  same
    string
    ~expected:"Welcome xhtmlboy to the secret area!"
    ~computed:(computed ~user:(true, "xhtmlboy") "qwerty");
  same string ~expected:"no user" ~computed:(computed "qwerty");
  same
    string
    ~expected:"not activated"
    ~computed:(computed ~user:(false, "xhtmlboy") "qwerty");
  same
    string
    ~expected:"bad password"
    ~computed:(computed ~user:(true, "xhtmlboy") "qwertyz")
;;

let test_doc_failable_calculator =
  test ~about:"failable" ~desc:"documentation example for failable calculator"
  @@ fun () ->
  let service =
    Service.failable
      Endpoint.(get (~/"calculator" /: char /: int /: int))
      []
      (fun operator x y _request ->
        let operator_f =
          match operator with
          | '+' -> Ok ( + )
          | '-' -> Ok ( - )
          | '*' -> Ok ( * )
          | '/' -> Ok ( / )
          | _ -> Error "unknown operator"
        in
        Lwt.return (Result.map (fun f -> f, operator, x, y) operator_f))
      ~succeed:(fun (f, c, x, y) _request ->
        let result = Format.asprintf "%d %c %d = %d" x c y (f x y) in
        Lwt.return result)
      ~failure:(fun _error _request ->
        Lwt.return "Unable to make the computation :(")
  in
  let computed c x y =
    Lwt_main.run
      (Service.choose
         `GET
         (Format.asprintf "/calculator/%c/%d/%d" c x y)
         [ service ]
         (fun _ -> Lwt.return "error")
         None)
  in
  same string ~expected:"12 + 30 = 42" ~computed:(computed '+' 12 30);
  same string ~expected:"12 * 10 = 120" ~computed:(computed '*' 12 10);
  same
    string
    ~expected:"Unable to make the computation :("
    ~computed:(computed 'v' 12 30)
;;

let test_doc_failable_with_provide_user =
  test
    ~about:"failable_with"
    ~desc:"documentation example for failable_with (user provider)"
  @@ fun () ->
  let is_authenticated handler request =
    match MS.find_opt "user" request with
    | None -> Lwt.return "no user"
    | Some _ -> handler request
  in
  let provide_user handler request =
    match MS.find_opt "user" request with
    | None -> Lwt.return "no user"
    | Some (activated, user) ->
      if activated then handler user request else Lwt.return "not activated"
  in
  let service =
    Service.failable_with
      Endpoint.(get (~/"secret" / "area" /: string))
      [ is_authenticated ]
      ~attached:provide_user
      (fun password user _request ->
        if password = "qwerty"
        then Lwt.return (Ok user)
        else Lwt.return (Error "invalid password"))
      ~succeed:(fun user _request ->
        Format.asprintf "Welcome %s to the secret area!" user |> Lwt.return)
      ~failure:(fun err _request -> Lwt.return err)
  in
  let computed ?user password =
    let req =
      Option.fold
        ~none:MS.empty
        ~some:(fun x -> make_request [ "user", x ])
        user
    in
    Lwt_main.run
      (Service.choose
         `GET
         ("/secret/area/" ^ password)
         [ service ]
         (fun _ -> Lwt.return "error")
         req)
  in
  same
    string
    ~expected:"Welcome xhtmlboy to the secret area!"
    ~computed:(computed ~user:(true, "xhtmlboy") "qwerty");
  same string ~expected:"no user" ~computed:(computed "qwerty");
  same
    string
    ~expected:"not activated"
    ~computed:(computed ~user:(false, "xhtmlboy") "qwerty");
  same
    string
    ~expected:"invalid password"
    ~computed:(computed ~user:(true, "xhtmlboy") "qwertyz")
;;

let cases =
  ( "Service"
  , [ test_choose_hello_world
    ; test_choose_hello_to
    ; test_choose_leave
    ; test_choose_show
    ; test_choose_without_candidate
    ; test_choose_hello_to_without_nickname
    ; test_choose_leave_without_nickname
    ; test_choose_show_without_nickname
    ; test_choose_show_with_failure_on_name_invariant
    ; test_choose_show_with_failure_on_nickname_invariant
    ; test_choose_show_with_failure_on_age_invariant
    ; test_doc_straight_hello
    ; test_doc_straight_sum
    ; test_doc_straight_with_provide_user
    ; test_doc_failable_calculator
    ; test_doc_failable_with_provide_user
    ] )
;;
