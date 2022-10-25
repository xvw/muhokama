open Caqti_request.Infix
open Caqti_type.Std

type t =
  { id : string
  ; title : string
  ; url : string
  ; creation_date : Ptime.t
  ; user : User_model.t
  }

let equal
  { id = id_a
  ; title = title_a
  ; url = url_a
  ; creation_date = creation_date_a
  ; user = user_a
  }
  { id = id_b
  ; title = title_b
  ; url = url_b
  ; creation_date = creation_date_b
  ; user = user_b
  }
  =
  String.equal id_a id_b
  && String.equal title_a title_b
  && String.equal url_a url_b
  && Ptime.equal creation_date_a creation_date_b
  && User_model.equal user_a user_b
;;

let pp ppf { id; title; url; creation_date; user } =
  let quoted = Fmt.(quote string) in
  Fmt.pf
    ppf
    "Shared_link { id = %a; title = %a; url = %a; creation_date = %a; user = \
     %a  }"
    quoted
    id
    quoted
    title
    quoted
    url
    (Ptime.pp_human ())
    creation_date
    User_model.pp
    user
;;

type creation_form =
  { creation_title : string
  ; creation_url : Uri.t
  }

let create =
  let query =
    (tup3 string string string ->. unit)
      {sql|
         INSERT INTO shared_links (
           shared_link_title,
           shared_link_url,
           shared_link_creation_date,
           user_id
         )
         VALUES (?, ?, NOW(), ?)
  |sql}
  in
  fun { creation_title; creation_url } user (module Db : Lib_db.T) ->
    let user_id = user.User_model.id in
    let url = Uri.to_string creation_url in
    Db.exec query (creation_title, url, user_id) |> Lib_db.try_
;;

let validate_creation ?(title_field = "link_title") ?(url_field = "link_url") =
  let open Lib_form in
  let formlet s =
    let+ title = required s title_field not_blank
    and+ url = required s url_field is_potential_url in
    { creation_title = title; creation_url = url }
  in
  run ~name:"Shared_link.create" formlet
;;
