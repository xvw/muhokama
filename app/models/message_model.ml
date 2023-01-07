open Lib_common
open Caqti_request.Infix
open Caqti_type.Std

type t =
  { id : string
  ; user_id : string
  ; user_name : string
  ; user_email : string
  ; creation_date : Ptime.t
  ; content : string
  }

type creation_form =
  { creation_content : string
  ; is_preview : bool
  }

type update_form = creation_form

let map_content f message = { message with content = f message.content }

let make ~id ~content user creation_date =
  { id
  ; user_id = user.User_model.id
  ; user_name = user.User_model.name
  ; user_email = user.User_model.email
  ; creation_date
  ; content
  }
;;

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
  fun user topic_id { creation_content; _ } (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? topic = Topic_model.get_by_id topic_id (module Db) in
    let user_id = user.User_model.id in
    Lib_db.transaction
      (fun () ->
        let input = topic_id, user_id, creation_content in
        let*? message_id = Db.find insert_message_query input |> Lib_db.try_ in
        let+? () = Db.exec update_topic_query topic_id |> Lib_db.try_ in
        message_id, topic)
      (module Db)
;;

let update =
  let update_message_query =
    (tup3 string string string ->. unit)
      {sql|
        UPDATE messages
        SET message_content = ?
        WHERE message_id = ? AND topic_id = ?
    |sql}
  in
  fun ~topic_id ~message_id { creation_content; _ } (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? _topic = Topic_model.get_by_id topic_id (module Db) in
    Db.exec update_message_query (creation_content, message_id, topic_id)
    |> Lib_db.try_
;;

let archive =
  let delete_message_query =
    (tup2 string string ->. unit)
      {sql|
          UPDATE messages
          SET message_archived = TRUE
          WHERE message_id = ? AND topic_id = ?
       |sql}
  and update_topic_query =
    (tup2 string string ->. unit)
      {sql|
          UPDATE topics
          SET
            topic_counter = COALESCE(topic_counter, 1) - 1,
            topic_update_date = COALESCE(
              (SELECT MAX(message_creation_date) FROM messages WHERE topic_id = ?),
              topic_creation_date)
           WHERE topic_id = ?
     |sql}
  in
  fun ~topic_id ~message_id (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? _topic = Topic_model.get_by_id topic_id (module Db) in
    Lib_db.transaction
      (fun () ->
        let*? () =
          Db.exec delete_message_query (message_id, topic_id) |> Lib_db.try_
        in
        Db.exec update_topic_query (topic_id, topic_id) |> Lib_db.try_)
      (module Db)
;;

let from_tuple
  (id, (user_id, (user_name, (user_email, (creation_date, content)))))
  =
  { id; user_id; user_name; user_email; creation_date; content }
;;

let message_repr =
  let ( & ) = tup2 in
  string & string & string & string & ptime & string
;;

let get_by_topic_id callback =
  let query =
    (string ->* message_repr)
      {sql|
          SELECT
            m.message_id,
            u.user_id,
            u.user_name,
            u.user_email,
            m.message_creation_date,
            m.message_content
          FROM messages AS m
            INNER JOIN users AS u ON m.user_id = u.user_id
          WHERE m.topic_id = ? AND m.message_archived = FALSE
          ORDER BY m.message_creation_date ASC
      |sql}
  in
  fun topic_id (module Db : Lib_db.T) ->
    let open Lwt_util in
    let+? list = Lib_db.try_ @@ Db.collect_list query topic_id in
    List.map Preface.Fun.(callback % from_tuple) list
;;

let get_by_topic_and_message_id =
  let query =
    (tup2 string string ->? message_repr)
      {sql|
        SELECT
         m.message_id,
         u.user_id,
         u.user_name,
         u.user_email,
         m.message_creation_date,
         m.message_content
        FROM messages AS m
          INNER JOIN users as u ON m.user_id = u.user_id
        WHERE m.topic_id = ? AND m.message_id = ? AND m.message_archived = FALSE
      |sql}
  in
  fun ~topic_id ~message_id (module Db : Lib_db.T) ->
    let open Lwt_util in
    let+? potential_result =
      Db.find_opt query (topic_id, message_id) |> Lib_db.try_
    in
    Option.map from_tuple potential_result
;;

let equal
  { id = id_a
  ; user_id = ui_a
  ; user_name = un_a
  ; user_email = ue_a
  ; creation_date = cd_a
  ; content = c_a
  }
  { id = id_b
  ; user_id = ui_b
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
  && String.equal ui_a ui_b
;;

let pp ppf { id; user_id; user_name; user_email; creation_date; content } =
  Fmt.pf
    ppf
    "Message {id = %a; user_id = %a; user_name = %a; user_email = %a; \
     creation_date = %a; content = %a}"
    Fmt.(quote string)
    id
    Fmt.(quote string)
    user_id
    Fmt.(quote string)
    user_name
    Fmt.(quote string)
    user_email
    Fmt.(quote @@ Ptime.pp_human ())
    creation_date
    Fmt.(quote string)
    content
;;

let created_message { creation_content; _ } = creation_content
let updated_message { creation_content; _ } = creation_content
let is_created_preview { is_preview; _ } = is_preview
let is_updated_preview { is_preview; _ } = is_preview

let validatation ?(content_field = "message_content") name fields =
  let open Lib_form in
  let formlet s =
    let+ content = required s content_field not_blank in
    let is_preview = List.exists (fun (k, _) -> k = "Preview") fields in
    { creation_content = content; is_preview }
  in
  run ~name formlet fields
;;

let validate_creation ?content_field =
  validatation ?content_field "Message.creation"
;;

let validate_update ?content_field =
  validatation ?content_field "Message.update"
;;
