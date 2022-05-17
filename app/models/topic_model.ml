open Lib_common
open Caqti_request.Infix
open Caqti_type.Std

module Listable = struct
  type t =
    { id : string
    ; category_name : string
    ; user_name : string
    ; user_email : string
    ; title : string
    ; responses : int
    }

  let from_tuple
      (id, (category_name, (user_name, (user_email, (title, responses)))))
    =
    { id; category_name; user_name; user_email; title; responses }
  ;;

  let equal
      { id = i_a
      ; category_name = c_a
      ; user_name = un_a
      ; user_email = ue_a
      ; title = t_a
      ; responses = r_a
      }
      { id = i_b
      ; category_name = c_b
      ; user_name = un_b
      ; user_email = ue_b
      ; title = t_b
      ; responses = r_b
      }
    =
    String.equal i_a i_b
    && String.equal c_a c_b
    && String.equal un_a un_b
    && String.equal ue_a ue_b
    && String.equal t_a t_b
    && Int.equal r_a r_b
  ;;

  let pp ppf { id; category_name; user_name; user_email; title; responses } =
    Fmt.pf
      ppf
      "Topic.listable { id = %a; category_name = %a; user_name = %a; \
       user_email = %a; title = %a; responses = %d }"
      Fmt.(quote string)
      id
      Fmt.(quote string)
      category_name
      Fmt.(quote string)
      user_name
      Fmt.(quote string)
      user_email
      Fmt.(quote string)
      title
      responses
  ;;
end

module Showable = struct
  type t =
    { category_name : string
    ; user_name : string
    ; user_email : string
    ; creation_date : Ptime.t
    ; title : string
    ; content : string
    }

  let from_tuple
      ( category_name
      , (user_name, (user_email, (creation_date, (title, content)))) )
    =
    { category_name; user_name; user_email; creation_date; title; content }
  ;;

  let from_tuple_with_error err =
    Option.fold
      ~none:Error.(Lwt.return @@ to_try err)
      ~some:Preface.Fun.(Lwt.return_ok % from_tuple)
  ;;

  let equal
      { category_name = c_a
      ; user_name = un_a
      ; user_email = ue_a
      ; creation_date = d_a
      ; title = t_a
      ; content = ct_a
      }
      { category_name = c_b
      ; user_name = un_b
      ; user_email = ue_b
      ; creation_date = d_b
      ; title = t_b
      ; content = ct_b
      }
    =
    String.equal c_a c_b
    && String.equal un_a un_b
    && String.equal ue_a ue_b
    && String.equal t_a t_b
    && String.equal ct_a ct_b
    && Ptime.equal d_a d_b
  ;;

  let pp
      ppf
      { category_name; user_name; user_email; creation_date; title; content }
    =
    Fmt.pf
      ppf
      "Topic.showable { category_name = %a; user_name = %a; user_email = %a; \
       creation_date = %a title = %a; content = %a }"
      Fmt.(quote string)
      category_name
      Fmt.(quote string)
      user_name
      Fmt.(quote string)
      user_email
      Fmt.(quote @@ Ptime.pp_human ())
      creation_date
      Fmt.(quote string)
      title
      Fmt.(quote string)
      content
  ;;
end

type creation_form =
  { creation_category_id : string
  ; creation_title : string
  ; creation_content : string
  }

let count =
  let query =
    (unit ->! int) {sql|
      SELECT COUNT(*) FROM topics
    |sql}
  in
  fun (module Db : Lib_db.T) -> Lib_db.try_ @@ Db.find query ()
;;

let create =
  let query =
    (tup4 string string string string ->! string)
      {sql|
          INSERT INTO topics (
             category_id,
             user_id,
             topic_creation_date,
             topic_title,
             topic_content
           )
           VALUES (?, ?, NOW(), ?, ?)
           RETURNING topic_id
      |sql}
  in
  fun user
      { creation_category_id; creation_title; creation_content }
      (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? _ = Category_model.get_by_id creation_category_id (module Db) in
    let user_id = user.User_model.id in
    Db.find
      query
      (creation_category_id, user_id, creation_title, creation_content)
    |> Lib_db.try_
;;

let get_by_id =
  let ( & ) = tup2 in
  let query =
    (string ->? (string & string & string & ptime & string & string))
      {sql|
          SELECT
            c.category_name,
            u.user_name,
            u.user_email,
            t.topic_creation_date,
            t.topic_title,
            t.topic_content
          FROM topics AS T
            INNER JOIN categories AS c ON t.category_id = c.category_id
            INNER JOIN users AS u ON t.user_id = u.user_id
          WHERE topic_id = ?
      |sql}
  in
  fun id (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? potential_topic = Lib_db.try_ @@ Db.find_opt query id in
    potential_topic
    |> Showable.from_tuple_with_error @@ Error.topic_id_not_found id
;;

let list_all callback =
  let ( & ) = tup2 in
  let query =
    (unit ->* (string & string & string & string & string & int))
      {sql|
          SELECT
            t.topic_id,
            c.category_name,
            u.user_name,
            u.user_email,
            t.topic_title,
            t.topic_counter
          FROM topics AS t
            INNER JOIN categories AS c ON t.category_id = c.category_id
            INNER JOIN users AS u ON t.user_id = u.user_id
          ORDER BY topic_update_date DESC
      |sql}
  in
  fun (module Db : Lib_db.T) ->
    let open Lwt_util in
    let+? list = Lib_db.try_ @@ Db.collect_list query () in
    List.map Preface.Fun.(callback % Listable.from_tuple) list
;;

let list_by_category category_name callback =
  let ( & ) = tup2 in
  let query =
    (string ->* (string & string & string & string & string & int))
      {sql|
          SELECT
            t.topic_id,
            c.category_name,
            u.user_name,
            u.user_email,
            t.topic_title,
            t.topic_counter
          FROM topics AS t
            INNER JOIN categories AS c ON t.category_id = c.category_id
            INNER JOIN users AS u ON t.user_id = u.user_id
          WHERE c.category_name = ?
          ORDER BY topic_update_date DESC
      |sql}
  in
  fun (module Db : Lib_db.T) ->
    let open Lwt_util in
    let+? list = Lib_db.try_ @@ Db.collect_list query category_name in
    List.map Preface.Fun.(callback % Listable.from_tuple) list
;;

let validate_creation
    ?(category_id_field = "category_id")
    ?(title_field = "topic_title")
    ?(content_field = "topic_content")
  =
  let open Lib_form in
  let formlet s =
    let+ category_id = required s category_id_field is_uuid
    and+ title = required s title_field not_blank
    and+ content = required s content_field not_blank in
    { creation_category_id = category_id
    ; creation_title = title
    ; creation_content = content
    }
  in
  run ~name:"Topic.creation" formlet
;;
