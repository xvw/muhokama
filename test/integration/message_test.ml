open Lib_common
open Lib_test
open Alcotest

let test_ensure_there_is_no_messages_at_starting =
  integration_test
    ~about:"count"
    ~desc:"when there is no messages, it should return 0"
    (fun _env db -> Models.Message.count db)
    (fun computed ->
      let expected = Ok 0 in
      same (Testable.try_ int) ~expected ~computed)
;;

let test_insert_message_in_non_existant_topic =
  integration_test
    ~about:"create"
    ~desc:
      "when the message is inserted into a non existant topic it should raise \
       an error"
    (fun _env db ->
      let open Lwt_util in
      let*? _, _, _, dplaindoux = create_users db in
      let*? _ =
        create_message
          dplaindoux
          "88f9c38c-d136-11ec-9d64-0242ac120002"
          "message"
          db
      in
      Lwt.return_ok ())
    (fun computed ->
      let expected =
        Error.(
          to_try @@ topic_id_not_found "88f9c38c-d136-11ec-9d64-0242ac120002")
      in
      same (Testable.try_ unit) ~expected ~computed)
;;

let test_add_some_messages =
  integration_test
    ~about:"create"
    ~desc:"add some valid messages"
    (fun _env db ->
      let open Lwt_util in
      let*? general, programming, muhokama = create_categories db in
      let*? grim, xhtmlboy, xvw, dplaindoux = create_users db in
      let*? topic_a =
        create_topic
          general.Models.Category.id
          grim
          "in general"
          "a message in general"
          db
      in
      let*? topic_b =
        create_topic
          programming.Models.Category.id
          xhtmlboy
          "in programming"
          "a message in programming"
          db
      in
      let*? topic_c =
        create_topic
          muhokama.Models.Category.id
          xvw
          "in muhokama"
          "a message in muhokama"
          db
      in
      let*? topic_d =
        create_topic
          general.Models.Category.id
          dplaindoux
          "also in general"
          "an other message in general"
          db
      in
      let*? _ = create_message xhtmlboy topic_a "an answer in topic_a" db in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ = create_message xvw topic_b "an answer in topic_b" db in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ = create_message dplaindoux topic_c "an answer in topic_c" db in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ = create_message grim topic_d "an answer in topic_d" db in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ = create_message xvw topic_a "an other answer in topic_a" db in
      let*? a =
        Models.Message.get_by_topic_id
          (fun x -> x.user_name ^ "-" ^ x.content)
          topic_a
          db
      in
      let*? b =
        Models.Message.get_by_topic_id
          (fun x -> x.user_name ^ "-" ^ x.content)
          topic_b
          db
      in
      let*? c =
        Models.Message.get_by_topic_id
          (fun x -> x.user_name ^ "-" ^ x.content)
          topic_c
          db
      in
      let*? d =
        Models.Message.get_by_topic_id
          (fun x -> x.user_name ^ "-" ^ x.content)
          topic_d
          db
      in
      return_ok [ a; b; c; d ])
    (fun computed ->
      let expected =
        Ok
          [ [ "xhtmlboy-an answer in topic_a"
            ; "xvw-an other answer in topic_a"
            ]
          ; [ "xvw-an answer in topic_b" ]
          ; [ "dplaindoux-an answer in topic_c" ]
          ; [ "grim-an answer in topic_d" ]
          ]
      in
      same (Testable.try_ (list (list string))) ~expected ~computed)
;;

let test_add_some_messages_and_archive_some =
  integration_test
    ~about:"create & archive"
    ~desc:"add some valid messages and make some archives"
    (fun _env db ->
      let open Lwt_util in
      let*? general, programming, muhokama = create_categories db in
      let*? grim, xhtmlboy, xvw, dplaindoux = create_users db in
      let*? topic_a =
        create_topic
          general.Models.Category.id
          grim
          "in general"
          "a message in general"
          db
      in
      let*? topic_b =
        create_topic
          programming.Models.Category.id
          xhtmlboy
          "in programming"
          "a message in programming"
          db
      in
      let*? topic_c =
        create_topic
          muhokama.Models.Category.id
          xvw
          "in muhokama"
          "a message in muhokama"
          db
      in
      let*? topic_d =
        create_topic
          general.Models.Category.id
          dplaindoux
          "also in general"
          "an other message in general"
          db
      in
      let*? _ = create_message xhtmlboy topic_a "an answer in topic_a" db in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ = create_message xvw topic_b "an answer in topic_b" db in
      let* () = Lwt_unix.sleep 0.1 in
      let*? _ = create_message dplaindoux topic_c "an answer in topic_c" db in
      let* () = Lwt_unix.sleep 0.1 in
      let*? id_a = create_message grim topic_d "an answer in topic_d" db in
      let* () = Lwt_unix.sleep 0.1 in
      let*? id_b = create_message xvw topic_a "an other answer in topic_a" db in
      let*? () = Models.Message.archive ~topic_id:topic_d ~message_id:id_a db in
      let*? () = Models.Message.archive ~topic_id:topic_a ~message_id:id_b db in
      let*? a =
        Models.Message.get_by_topic_id
          (fun x -> x.user_name ^ "-" ^ x.content)
          topic_a
          db
      in
      let*? b =
        Models.Message.get_by_topic_id
          (fun x -> x.user_name ^ "-" ^ x.content)
          topic_b
          db
      in
      let*? c =
        Models.Message.get_by_topic_id
          (fun x -> x.user_name ^ "-" ^ x.content)
          topic_c
          db
      in
      let*? d =
        Models.Message.get_by_topic_id
          (fun x -> x.user_name ^ "-" ^ x.content)
          topic_d
          db
      in
      return_ok [ a; b; c; d ])
    (fun computed ->
      let expected =
        Ok
          [ [ "xhtmlboy-an answer in topic_a" ]
          ; [ "xvw-an answer in topic_b" ]
          ; [ "dplaindoux-an answer in topic_c" ]
          ; []
          ]
      in
      same (Testable.try_ (list (list string))) ~expected ~computed)
;;

let cases =
  ( "Message"
  , [ test_ensure_there_is_no_messages_at_starting
    ; test_insert_message_in_non_existant_topic
    ; test_add_some_messages
    ; test_add_some_messages_and_archive_some
    ] )
;;
