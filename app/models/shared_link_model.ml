open Caqti_request.Infix
open Caqti_type.Std
open Lib_common

type t =
  { id : string
  ; title : string
  ; url : string
  ; creation_date : Ptime.t
  ; user : User_model.t
  }

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

module Listable = struct
  type t =
    { id : string
    ; title : string
    ; url : string
    ; creation_date : Ptime.t
    ; user_name : string
    ; user_email : string
    }

  let from_tuple (id, (title, (url, (creation_date, (user_name, user_email))))) =
    { id; title; url; creation_date; user_name; user_email }
  ;;

  let pp ppf { id; title; url; creation_date; user_name; user_email } =
    Fmt.pf
      ppf
      "Shared_link.listable { id = %a; title = %a; url = %a; creation_date = \
       %a; user_name = %a; user_email = %a }"
      Fmt.(quote string)
      id
      Fmt.(quote string)
      title
      Fmt.(quote string)
      url
      Fmt.(quote @@ Ptime.pp_human ())
      creation_date
      Fmt.(quote string)
      user_name
      Fmt.(quote string)
      user_email
  ;;
end

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
  fun user { creation_title; creation_url } (module Db : Lib_db.T) ->
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

let list_all callback =
  let ( & ) = tup2 in
  let query =
    (unit ->* (string & string & string & ptime & string & string))
      {sql|
          SELECT
            shared_link_id,
            shared_link_title,
            shared_link_url,
            shared_link_creation_date,
            user_name,
            user_email
          FROM shared_links
          NATURAL INNER JOIN users
          ORDER BY shared_link_creation_date DESC
      |sql}
  in
  fun (module Db : Lib_db.T) ->
    let open Lwt_util in
    let+? list = Lib_db.try_ @@ Db.collect_list query () in
    List.map Preface.Fun.(callback % Listable.from_tuple) list
;;
