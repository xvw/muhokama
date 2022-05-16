open Lib_common
open Caqti_request.Infix
open Caqti_type.Std

type t =
  { id : string
  ; category : Category_model.t
  ; user : User_model.t
  ; creation_date : Ptime.t
  ; title : string
  ; content : string
  }

type creation_form =
  { creation_category_id : string
  ; creation_title : string
  ; creation_content : string
  }

let count =
  let query = (unit ->! int) "SELECT COUNT(*) FROM topics" in
  fun (module Db : Lib_db.T) -> Lib_db.try_ @@ Db.find query ()
;;

let create =
  let query =
    (tup4 string string string string ->! string)
      "INSERT INTO topics (category_id, user_id, topic_creation_date, \
       topic_title, topic_content) VALUES (?, ?, NOW(), ?, ?) RETURNING \
       topic_id"
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

let from_tuple
    ( topic_id
    , ( creation_date
      , ( topic_title
        , ( topic_content
          , ( category_id
            , ( category_name
              , ( category_description
                , (user_id, (user_name, (user_email, user_state))) ) ) ) ) ) )
    )
  =
  let category =
    Category_model.from_tuple (category_id, category_name, category_description)
  and user =
    User_model.from_tuple (user_id, user_name, user_email, user_state)
  in
  { id = topic_id
  ; user
  ; category
  ; creation_date
  ; title = topic_title
  ; content = topic_content
  }
;;

let from_tuple_with_error err =
  Option.fold
    ~none:Error.(Lwt.return @@ to_try err)
    ~some:Preface.Fun.(Lwt.return_ok % from_tuple)
;;

let topic_return_type =
  (* This is a little bit sad and we should find a way to refactor it!*)
  let ( & ) = tup2 in
  string
  & ptime
  & string
  & string
  & string
  & string
  & string
  & string
  & string
  & string
  & string
;;

let topic_select_str =
  "t.topic_id, t.topic_creation_date, t.topic_title, t.topic_content, \
   c.category_id, c.category_name, c.category_description, u.user_id, \
   u.user_name, u.user_email, u.user_state"
;;

let get_by_id =
  let query =
    (string ->? topic_return_type)
      (Fmt.str
         "SELECT %s FROM topics AS t INNER JOIN categories AS c ON \
          t.category_id = c.category_id INNER JOIN users AS u ON t.user_id = \
          u.user_id WHERE topic_id = ?"
         topic_select_str)
  in
  fun id (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? potential_topic = Lib_db.try_ @@ Db.find_opt query id in
    potential_topic |> from_tuple_with_error @@ Error.topic_id_not_found id
;;

let list ?filter callback =
  let filter =
    Option.fold
      ~none:""
      ~some:(fun category -> Fmt.str " WHERE c.category_id = '%s'" category)
      filter
  in
  let query =
    (unit ->* topic_return_type)
      (Fmt.str
         "SELECT %s FROM topics AS t INNER JOIN categories AS c ON \
          t.category_id = c.category_id INNER JOIN users AS u ON t.user_id = \
          u.user_id %s ORDER BY topic_creation_date DESC"
         topic_select_str
         filter)
  in
  fun (module Db : Lib_db.T) ->
    let open Lwt_util in
    let+? list = Lib_db.try_ @@ Db.collect_list query () in
    List.map Preface.Fun.(callback % from_tuple) list
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

let equal
    { id = id_a
    ; category = category_a
    ; user = user_a
    ; creation_date = creation_date_a
    ; title = title_a
    ; content = content_a
    }
    { id = id_b
    ; category = category_b
    ; user = user_b
    ; creation_date = creation_date_b
    ; title = title_b
    ; content = content_b
    }
  =
  String.equal id_a id_b
  && Category_model.equal category_a category_b
  && User_model.equal user_a user_b
  && Ptime.equal creation_date_a creation_date_b
  && String.equal title_a title_b
  && String.equal content_a content_b
;;

let pp ppf { id; category; user; creation_date; title; content } =
  let quoted = Fmt.(quote string) in
  Fmt.pf
    ppf
    "Topic { id = %a; category = %a; user = %a; creation_date = %a; title = \
     %a; content = %a }"
    quoted
    id
    Category_model.pp
    category
    User_model.pp
    user
    Ptime.pp
    creation_date
    quoted
    title
    quoted
    content
;;
