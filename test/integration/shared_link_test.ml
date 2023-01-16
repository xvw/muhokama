open Lib_common
open Lib_test
open Alcotest

let test_ensure_there_is_no_shared_link_at_starting =
  integration_test
    ~about:"count"
    ~desc:"when there is no shared_link, it should return 0"
    (fun _env db -> Models.Shared_link.count db)
    (fun computed ->
      let expected = Ok 0 in
      same (Testable.try_ int) ~expected ~computed)
;;

let test_list_all_when_there_is_no_shared_links =
  integration_test
    ~about:"list_all"
    ~desc:"when there is no shared_link, it should return an empty list"
    (fun _env db ->
      Models.Shared_link.list_all
        Models.Shared_link.Listable.(fun x -> x.title)
        db)
    (fun computed ->
      let expected = Ok [] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_list_all_when_there_is_some_shared_links =
  integration_test
    ~about:"list_all"
    ~desc:"when there is some shared_links, it should return it"
    (fun _env db ->
      let open Lwt_util in
      let*? grim, xhtmlboy, _xvw, _dplaindoux = create_users db in
      let*? _ =
        create_shared_link grim "A nice place to talk" "https://muhokama.fun" db
      in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ =
        create_shared_link
          xhtmlboy
          "One day I will be in there"
          "https://blogs.oracle.com/java/category/j-java-champions"
          db
      in
      Models.Shared_link.list_all
        Models.Shared_link.Listable.(fun x -> x.title)
        db)
    (fun computed ->
      let expected =
        Ok [ "One day I will be in there"; "A nice place to talk" ]
      in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_try_to_add_some_shared_links =
  integration_test
    ~about:"create"
    ~desc:"try to add some valid shared_links"
    (fun _env db ->
      let open Lwt_util in
      let*? grim, xhtmlboy, _xvw, _dplaindoux = create_users db in
      let*? _ =
        create_shared_link grim "A nice place to talk" "https://muhokama.fun" db
      in
      let*? _ =
        create_shared_link
          xhtmlboy
          "One day I will be in there"
          "https://blogs.oracle.com/java/category/j-java-champions"
          db
      in
      let+? counter = Models.Shared_link.count db in
      counter)
    (fun result ->
      match result with
      | Ok counter -> same int ~expected:2 ~computed:counter
      | _ -> assert false)
;;

let cases =
  ( "Shared_link"
  , [ test_ensure_there_is_no_shared_link_at_starting
    ; test_try_to_add_some_shared_links
    ; test_list_all_when_there_is_no_shared_links
    ; test_list_all_when_there_is_some_shared_links
    ] )
;;
