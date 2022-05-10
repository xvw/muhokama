open Lib_common
open Util
open Caqti_request.Infix
open Caqti_type.Std

type t =
  { id : string
  ; name : string
  ; description : string
  }

type creation_form =
  { creation_name : string
  ; creation_description : string
  }

let from_tuple (id, name, description) = { id; name; description }

let from_tuple_with_error err =
  Option.fold
    ~none:Error.(Lwt.return @@ to_try err)
    ~some:Preface.Fun.(Lwt.return_ok % from_tuple)
;;

let count =
  let query = (unit ->! int) @@ "SELECT COUNT(*) FROM categories" in
  fun (module Db : Lib_db.T) -> Lib_db.try_ @@ Db.find query ()
;;

let list callback =
  let query =
    (unit ->* tup3 string string string)
      "SELECT category_id, category_name, category_description FROM categories \
       ORDER BY category_name"
  in
  fun (module Db : Lib_db.T) ->
    let open Lwt_util in
    let+? list = Lib_db.try_ @@ Db.collect_list query () in
    List.map Preface.Fun.(callback % from_tuple) list
;;

let get_by_id =
  let query =
    (string ->? tup3 string string string)
      "SELECT category_id, category_name, category_description WHERE \
       category_id = ?"
  in
  fun id (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? potential_category = Lib_db.try_ @@ Db.find_opt query id in
    potential_category
    |> from_tuple_with_error @@ Error.category_id_not_found id
;;

let get_by_name =
  let query =
    (string ->? tup3 string string string)
      "SELECT category_id, category_name, category_description WHERE \
       category_name = ?"
  in
  fun name (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? potential_category = Lib_db.try_ @@ Db.find_opt query name in
    potential_category
    |> from_tuple_with_error @@ Error.category_name_not_found name
;;

let report_non_integrity_violation =
  let query =
    (string ->! int) "SELECT COUNT(*) FROM categories WHERE category_name = ? "
  in
  fun name (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? counter = Lib_db.try_ @@ Db.find query name in
    match counter with
    | 0 -> return_ok ()
    | _ -> return Error.(to_try @@ category_name_already_taken name)
;;

let create =
  let query =
    (tup2 string string ->. unit)
      "INSERT INTO categories (category_name, category_description) VALUES (?, \
       ?)"
  in
  fun { creation_name = name; creation_description = description }
      (module Db : Lib_db.T) ->
    let open Lwt_util in
    let*? () = report_non_integrity_violation name (module Db) in
    Db.exec query (name, description) |> Lib_db.try_
;;

let validate_creation
    ?(name_field = "category_name")
    ?(description_field = "category_description")
  =
  let open Lib_form in
  let formlet s =
    let+ name = required s name_field (not_blank $ normalize_name)
    and+ description = required s description_field not_blank in
    { creation_name = name; creation_description = description }
  in
  run ~name:"Category.creation" formlet
;;

let equal
    { id = id_a; name = name_a; description = description_a }
    { id = id_b; name = name_b; description = description_b }
  =
  String.equal id_a id_b
  && String.equal name_a name_b
  && String.equal description_a description_b
;;

let pp ppf { id; name; description } =
  let quoted = Fmt.(quote string) in
  Fmt.pf
    ppf
    "Category { id = %a; name = %a; description = %a }"
    quoted
    id
    quoted
    name
    quoted
    description
;;
