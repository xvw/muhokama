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
        same string ~expected:"An example" ~computed:topic_a.Models.Topic.title;
        same
          string
          ~expected:"This is my first message"
          ~computed:topic_a.Models.Topic.content;
        same string ~expected:"grim" ~computed:topic_a.Models.Topic.user.name;
        same
          string
          ~expected:"An other example"
          ~computed:topic_b.Models.Topic.title;
        same
          string
          ~expected:"This is my first message too"
          ~computed:topic_b.Models.Topic.content;
        same
          string
          ~expected:"xhtmlboy"
          ~computed:topic_b.Models.Topic.user.name
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

let cases =
  ( "Topic"
  , [ test_ensure_there_is_no_topic_at_starting
    ; test_try_to_add_some_topics
    ; test_add_when_category_does_not_exists
    ] )
;;
