open Lib_common
open Lib_test
open Alcotest

let test_ensure_there_is_no_topic_at_starting =
  integration_test
    ~about:"count"
    ~desc:"when there is no topic, it should return 0"
    (fun _env db -> Models.Topic.count db)
    (fun computed ->
      let expected = Ok 0 in
      same (Testable.try_ int) ~expected ~computed)
;;

let test_list_all_when_there_is_no_topics =
  integration_test
    ~about:"list_all"
    ~desc:"when there is no topic, it should return an empty list"
    (fun _env db ->
      Models.Topic.list_all Models.Topic.Listable.(fun x -> x.title) db)
    (fun computed ->
      let expected = Ok [] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_list_by_when_there_is_no_topics =
  integration_test
    ~about:"list_by_category"
    ~desc:"when there is no topic, it should return an empty list"
    (fun _env db ->
      Models.Topic.list_by_category
        "programming"
        Models.Topic.Listable.(fun x -> x.title)
        db)
    (fun computed ->
      let expected = Ok [] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_list_by_author_when_there_is_no_topics =
  integration_test
    ~about:"list_by_author"
    ~desc:"when there is no topic, it should return an empty list"
    (fun _env db ->
      let open Lwt_util in
      let*? gholad = make_user "gholad" "gholad@gmail.com" "1234567" db in
      Models.Topic.list_by_author
        gholad.id
        Models.Topic.Listable.(fun x -> x.title)
        db)
    (fun computed ->
      let expected = Ok [] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_list_by_author_when_there_is_some_topics =
  integration_test
    ~about:"list_by_author"
    ~desc:"when there is some topics, it should return it"
    (fun _env db ->
      let open Lwt_util in
      let*? gholad = make_user "gholad" "gholad@gmail.com" "1234567" db in
      let*? larry_gholad =
        make_user "larry_gholad" "larry_gholad@gmail.com" "7654321" db
      in
      let*? general, programming, muhokama = create_categories db in
      let*? _ =
        create_topic
          general.Models.Category.id
          gholad
          "My presentation"
          "Hey ! My name is gholad"
          db
      in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ =
        create_topic
          muhokama.Models.Category.id
          gholad
          "A profile page"
          "I want to add a profile page to muhokama"
          db
      in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ =
        create_topic
          programming.Models.Category.id
          larry_gholad
          "Introduction to GADT"
          "I'm looking for a friendly introduction to GADT in OCaml"
          db
      in
      Models.Topic.list_by_author
        gholad.id
        Models.Topic.Listable.(fun x -> x.title)
        db)
    (fun computed ->
      let expected = Ok [ "A profile page"; "My presentation" ] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_list_all_when_there_is_some_topics =
  integration_test
    ~about:"list_all"
    ~desc:"when there is some topics, it should return it"
    (fun _env db ->
      let open Lwt_util in
      let*? general, programming, _muhokama = create_categories db in
      let*? grim, xhtmlboy, _xvw, _dplaindoux = create_users db in
      let*? _ =
        create_topic
          general.Models.Category.id
          grim
          "An example"
          "This is my first message"
          db
      in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ =
        create_topic
          programming.Models.Category.id
          xhtmlboy
          "An other example"
          "This is my first message too"
          db
      in
      Models.Topic.list_all Models.Topic.Listable.(fun x -> x.title) db)
    (fun computed ->
      let expected = Ok [ "An other example"; "An example" ] in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_list_by_when_there_is_some_topics =
  integration_test
    ~about:"list_by_category"
    ~desc:"when there is some topics, it should return it"
    (fun _env db ->
      let open Lwt_util in
      let*? general, programming, _muhokama = create_categories db in
      let*? grim, xhtmlboy, _xvw, _dplaindoux = create_users db in
      let*? _ =
        create_topic
          general.Models.Category.id
          grim
          "An example"
          "This is my first message"
          db
      in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ =
        create_topic
          programming.Models.Category.id
          xhtmlboy
          "An other example"
          "This is my first message too"
          db
      in
      let*? a =
        Models.Topic.list_by_category
          programming.Models.Category.name
          Models.Topic.Listable.(fun x -> x.title)
          db
      in
      let+? b =
        Models.Topic.list_by_category
          general.Models.Category.name
          Models.Topic.Listable.(fun x -> x.title)
          db
      in
      a, b)
    (fun computed ->
      let expected = Ok ([ "An other example" ], [ "An example" ]) in
      same
        (Testable.try_ (pair (list string) (list string)))
        ~expected
        ~computed)
;;

let test_try_to_add_some_topics =
  integration_test
    ~about:"create"
    ~desc:"try to add some valid topics"
    (fun _env db ->
      let open Lwt_util in
      let*? general, programming, _muhokama = create_categories db in
      let*? grim, xhtmlboy, _xvw, _dplaindoux = create_users db in
      let*? id_a =
        create_topic
          general.Models.Category.id
          grim
          "An example"
          "This is my first message"
          db
      in
      let*? id_b =
        create_topic
          programming.Models.Category.id
          xhtmlboy
          "An other example"
          "This is my first message too"
          db
      in
      let*? topic_a = Models.Topic.get_by_id id_a db in
      let*? topic_b = Models.Topic.get_by_id id_b db in
      let+? counter = Models.Topic.count db in
      counter, topic_a, topic_b)
    (fun result ->
      match result with
      | Ok (counter, topic_a, topic_b) ->
        same int ~expected:2 ~computed:counter;
        same
          string
          ~expected:"An example"
          ~computed:topic_a.Models.Topic.Showable.title;
        same
          string
          ~expected:"This is my first message"
          ~computed:topic_a.content;
        same string ~expected:"grim" ~computed:topic_a.user_name;
        same string ~expected:"An other example" ~computed:topic_b.title;
        same
          string
          ~expected:"This is my first message too"
          ~computed:topic_b.content;
        same string ~expected:"xhtmlboy" ~computed:topic_b.user_name
      | _ -> assert false)
;;

let test_add_when_category_does_not_exists =
  integration_test
    ~about:"create"
    ~desc:"when the category does not exists, it should raise an error"
    (fun _env db ->
      let open Lwt_util in
      let*? grim, _, _, _ = create_users db in
      create_topic
        "88f9c38c-d136-11ec-9d64-0242ac120002"
        grim
        "An example"
        "A text"
        db)
    (fun computed ->
      let expected =
        Error.(
          to_try @@ category_id_not_found "88f9c38c-d136-11ec-9d64-0242ac120002")
      in
      same (Testable.try_ string) ~expected ~computed)
;;

let test_list_all_when_there_is_some_archived_topics =
  integration_test
    ~about:"list_all & archive"
    ~desc:"when there is some archived topics, it should return discard-it"
    (fun _env db ->
      let open Lwt_util in
      let*? general, programming, _muhokama = create_categories db in
      let*? grim, xhtmlboy, _xvw, _dplaindoux = create_users db in
      let*? id =
        create_topic
          general.Models.Category.id
          grim
          "An example"
          "This is my first message"
          db
      in
      let*? () = Models.Topic.archive id db in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ =
        create_topic
          programming.Models.Category.id
          xhtmlboy
          "An other example"
          "This is my first message too"
          db
      in
      let* () = Lwt_unix.sleep 0.1 in
      let*? id =
        create_topic
          programming.Models.Category.id
          xhtmlboy
          "An other other example"
          "This is my second message"
          db
      in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ =
        create_topic
          programming.Models.Category.id
          xhtmlboy
          "An other other other example"
          "This is my third message"
          db
      in
      let*? () = Models.Topic.archive id db in
      Models.Topic.list_all Models.Topic.Listable.(fun x -> x.title) db)
    (fun computed ->
      let expected =
        Ok [ "An other other other example"; "An other example" ]
      in
      same (Testable.try_ @@ list string) ~expected ~computed)
;;

let test_try_to_update_some_topics =
  integration_test
    ~about:"update"
    ~desc:"try to add some valid topics"
    (fun _env db ->
      let open Lwt_util in
      let*? general, programming, _muhokama = create_categories db in
      let*? grim, xhtmlboy, _xvw, _dplaindoux = create_users db in
      let*? id_a =
        create_topic
          general.Models.Category.id
          grim
          "An example"
          "This is my first message"
          db
      in
      let*? id_b =
        create_topic
          programming.Models.Category.id
          xhtmlboy
          "An other example"
          "This is my first message too"
          db
      in
      let*? () =
        update_topic
          id_a
          general.Models.Category.id
          "An edited example"
          "This is my first edited message"
          db
      in
      let*? () =
        update_topic
          id_b
          programming.Models.Category.id
          "An other edited example"
          "This is my first edited message too"
          db
      in
      let*? topic_a = Models.Topic.get_by_id id_a db in
      let*? topic_b = Models.Topic.get_by_id id_b db in
      let+? counter = Models.Topic.count db in
      counter, topic_a, topic_b)
    (fun result ->
      match result with
      | Ok (counter, topic_a, topic_b) ->
        same int ~expected:2 ~computed:counter;
        same
          string
          ~expected:"An edited example"
          ~computed:topic_a.Models.Topic.Showable.title;
        same
          string
          ~expected:"This is my first edited message"
          ~computed:topic_a.content;
        same string ~expected:"grim" ~computed:topic_a.user_name;
        same string ~expected:"An other edited example" ~computed:topic_b.title;
        same
          string
          ~expected:"This is my first edited message too"
          ~computed:topic_b.content;
        same string ~expected:"xhtmlboy" ~computed:topic_b.user_name
      | _ -> assert false)
;;

let cases =
  ( "Topic"
  , [ test_ensure_there_is_no_topic_at_starting
    ; test_try_to_add_some_topics
    ; test_add_when_category_does_not_exists
    ; test_list_all_when_there_is_no_topics
    ; test_list_all_when_there_is_some_topics
    ; test_list_by_when_there_is_no_topics
    ; test_list_by_when_there_is_some_topics
    ; test_list_all_when_there_is_some_archived_topics
    ; test_try_to_update_some_topics
    ; test_list_by_author_when_there_is_no_topics
    ; test_list_by_author_when_there_is_some_topics
    ] )
;;
