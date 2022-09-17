open Lib_common
open Caqti_request.Infix
open Caqti_type.Std

type t =
  { id : string
  ; user_name : string
  ; user_email : string
  ; creation_date : Ptime.t
  ; content : string
  }

type creation_form = { creation_content : string }

let map_content f message = { message with content = f message.content }

let count =
  let query =
    (unit ->! int) {sql|
      SELECT COUNT(*) FROM messages
    |sql}
  in
  fun (module Db : Lib_db.T) -> Lib_db.try_ @@ Db.find query ()
;;

let create =
  let insert_message_query =
    (tup3 string string string ->! string)
      {sql|
          INSERT INTO messages (
            topic_id,
            user_id,
            message_creation_date,
            message_content
          )
         VALUES (?, ?, NOW(), ?)
         RETURNING message_id
      |sql}
  and update_topic_query =
    (string ->. unit)
      {sql|
          UPDATE topics
          SET
            topic_update_date = NOW(),
            topic_counter = COALESCE(topic_counter, 0) + 1
          WHERE topic_id = ?
    |sql}
  in
  fun user topic_id { creation_content } (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? _topic = Topic_model.get_by_id topic_id (module Db) in
    let user_id = user.User_model.id in
    Lib_db.transaction
      (fun () ->
        let input = topic_id, user_id, creation_content in
        let*? message_id = Db.find insert_message_query input |> Lib_db.try_ in
        let+? () = Db.exec update_topic_query topic_id |> Lib_db.try_ in
        message_id)
      (module Db)
;;

let from_tuple (id, (user_name, (user_email, (creation_date, content)))) =
  { id; user_name; user_email; creation_date; content }
;;

let get_by_topic_id callback =
  let ( & ) = tup2 in
  let query =
    (string ->* (string & string & string & ptime & string))
      {sql|
          SELECT
            m.message_id,
            u.user_name,
            u.user_email,
            m.message_creation_date,
            m.message_content
          FROM messages AS m
            INNER JOIN users AS u ON m.user_id = u.user_id
          WHERE m.topic_id = ?
          ORDER BY m.message_creation_date ASC
      |sql}
  in
  fun topic_id (module Db : Lib_db.T) ->
    let open Lwt_util in
    let+? list = Lib_db.try_ @@ Db.collect_list query topic_id in
    List.map Preface.Fun.(callback % from_tuple) list
;;

let equal
  { id = id_a
  ; user_name = un_a
  ; user_email = ue_a
  ; creation_date = cd_a
  ; content = c_a
  }
  { id = id_b
  ; user_name = un_b
  ; user_email = ue_b
  ; creation_date = cd_b
  ; content = c_b
  }
  =
  String.equal id_a id_b
  && String.equal un_a un_b
  && String.equal ue_a ue_b
  && Ptime.equal cd_a cd_b
  && String.equal c_a c_b
;;

let pp ppf { id; user_name; user_email; creation_date; content } =
  Fmt.pf
    ppf
    "Message {id = %a; user_name = %a; user_email = %a; creation_date = %a; \
     content = %a}"
    Fmt.(quote string)
    id
    Fmt.(quote string)
    user_name
    Fmt.(quote string)
    user_email
    Fmt.(quote @@ Ptime.pp_human ())
    creation_date
    Fmt.(quote string)
    content
;;

let validate_creation ?(content_field = "message_content") =
  let open Lib_form in
  let formlet s =
    let+ content = required s content_field not_blank in
    { creation_content = content }
  in
  run ~name:"Message.creation" formlet
;;
