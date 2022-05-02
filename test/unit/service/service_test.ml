open Alcotest
open Lib_test
open Lib_service

module E = struct
  open Endpoint

  let hello_world () = get (~/"hello" / "world")
  let hello () = get (~/"hello" /: string)
  let good_bye () = post (~/"good-bye" /: string /: int)
end

let push_request new_value f req = f (req ^ new_value)

module S = struct
  let hello_world =
    Service.make
      ~middlewares:[ push_request "111"; push_request "222" ]
      ~:E.hello_world
      (fun s _ -> Format.asprintf "service hello_world: %s" s)
      (fun request -> "Hello World, request, " ^ request)
  ;;

  let hello =
    Service.make
      ~:E.hello
      (fun s _ -> Format.asprintf "service hello: %s" s)
      (fun user_name request -> "Hello " ^ user_name ^ ", request, " ^ request)
  ;;

  let good_bye =
    Service.make
      ~:E.good_bye
      (fun s _ -> Format.asprintf "service goodbye: %s" s)
      (fun user_name counter request ->
        "Good bye "
        ^ user_name
        ^ "("
        ^ string_of_int counter
        ^ "), request, "
        ^ request)
  ;;
end

module S2 = struct
  let hello_world =
    Service.regular
      ~middlewares:[ push_request "111"; push_request "222" ]
      ~:E.hello_world
      (fun request -> Lwt.return @@ "Hello world, " ^ request)
  ;;

  let hello =
    Service.failable
      ~:E.hello
      ~ok:(fun result _request -> Lwt.return result)
      ~error:(fun err _ -> Lwt.return err)
      (fun user_name _request ->
        Lwt.return
          (match user_name with
          | "" -> Error "Invalid name"
          | name -> Ok ("Hello " ^ name)))
  ;;

  let good_bye =
    Service.failable
      ~:E.good_bye
      ~error:(fun err _request -> Lwt.return err)
      ~ok:(fun result _request -> Lwt.return result)
      (fun user_name counter _request ->
        let res =
          if counter < 0
          then Error "too small"
          else (
            match user_name with
            | "" -> Error "Invalid name"
            | name ->
              Ok ("Good bye " ^ name ^ " for the " ^ string_of_int counter ^ "x"))
        in
        Lwt.return res)
  ;;
end

let choose_1 method_ uri default_request given_request =
  Service.choose
    method_
    uri
    S.[ hello_world; hello; good_bye ]
    (Fun.const default_request)
    given_request
;;

let choose_2 method_ uri default_request given_request =
  Service.choose
    method_
    uri
    S2.[ hello_world; hello; good_bye ]
    (Fun.const (Lwt.return default_request))
    given_request
;;

let test_1_choose_1 =
  test ~about:"choose" ~desc:"choose_1 test 1, boot [hello_world]"
  @@ fun () ->
  let meth = `GET
  and uri = "/hello/world" in
  let expected = "service hello_world: Hello World, request, 200111222"
  and computed = choose_1 meth uri "404" "200" in
  same string ~expected ~computed
;;

let test_2_choose_1 =
  test ~about:"choose" ~desc:"choose_1 test 2, boot [hello]"
  @@ fun () ->
  let meth = `GET
  and uri = "/hello/Antoine" in
  let expected = "service hello: Hello Antoine, request, 200"
  and computed = choose_1 meth uri "404" "200" in
  same string ~expected ~computed
;;

let test_3_choose_1 =
  test ~about:"choose" ~desc:"choose_1 test 3, boot [good_bye]"
  @@ fun () ->
  let meth = `POST
  and uri = "/good-bye/Antoine/45" in
  let expected = "service goodbye: Good bye Antoine(45), request, 200"
  and computed = choose_1 meth uri "404" "200" in
  same string ~expected ~computed
;;

let test_4_choose_1 =
  test ~about:"choose" ~desc:"choose_1 test 4, fail on choosing service"
  @@ fun () ->
  let meth = `POST
  and uri = "/goodBye/Antoine/45" in
  let expected = "404"
  and computed = choose_1 meth uri "404" "200" in
  same string ~expected ~computed
;;

let test_1_choose_2 =
  test ~about:"choose" ~desc:"choose_2 test 1, boot [hello_world]"
  @@ fun () ->
  let meth = `GET
  and uri = "/hello/world" in
  let expected = "Hello world, 200111222"
  and computed = Lwt_main.run @@ choose_2 meth uri "404" "200" in
  same string ~expected ~computed
;;

let test_2_choose_2 =
  test ~about:"choose" ~desc:"choose_2 test 2, boot [hello]"
  @@ fun () ->
  let meth = `GET
  and uri = "/hello/Antoine" in
  let expected = "Hello Antoine"
  and computed = Lwt_main.run @@ choose_2 meth uri "404" "200" in
  same string ~expected ~computed
;;

let test_3_choose_2 =
  test ~about:"choose" ~desc:"choose_2 test 3, boot [hello]"
  @@ fun () ->
  let meth = `GET
  and uri = "/hello/" in
  let expected = "Invalid name"
  and computed = Lwt_main.run @@ choose_2 meth uri "404" "200" in
  same string ~expected ~computed
;;

let test_4_choose_2 =
  test ~about:"choose" ~desc:"choose_2 test 4, boot [good_bye]"
  @@ fun () ->
  let meth = `POST
  and uri = "/good-bye/Antoine/45" in
  let expected = "Good bye Antoine for the 45x"
  and computed = Lwt_main.run @@ choose_2 meth uri "404" "200" in
  same string ~expected ~computed
;;

let test_5_choose_2 =
  test ~about:"choose" ~desc:"choose_2 test 5, boot [good_bye]"
  @@ fun () ->
  let meth = `POST
  and uri = "/good-bye//45" in
  let expected = "Invalid name"
  and computed = Lwt_main.run @@ choose_2 meth uri "404" "200" in
  same string ~expected ~computed
;;

let test_6_choose_2 =
  test ~about:"choose" ~desc:"choose_2 test 6, boot [good_bye]"
  @@ fun () ->
  let meth = `POST
  and uri = "/good-bye/Antoine/-7" in
  let expected = "too small"
  and computed = Lwt_main.run @@ choose_2 meth uri "404" "200" in
  same string ~expected ~computed
;;

let cases =
  ( "Service"
  , [ test_1_choose_1
    ; test_2_choose_1
    ; test_3_choose_1
    ; test_4_choose_1
    ; test_1_choose_2
    ; test_2_choose_2
    ; test_3_choose_2
    ; test_4_choose_2
    ; test_5_choose_2
    ; test_6_choose_2
    ] )
;;
