open Lib_common
open Lib_test
open Alcotest

let valid_query =
  let open Caqti_request.Infix in
  let open Caqti_type.Std in
  let query =
    (tup2 string string ->. unit)
      "INSERT INTO categories (category_name, category_description) VALUES (?, \
       ?)"
  in
  fun name desc (module Db : Lib_db.T) ->
    Db.exec query (name, desc) |> Lib_db.try_
;;

let invalid_query =
  let open Caqti_request.Infix in
  let open Caqti_type.Std in
  let query =
    (tup2 string string ->. unit)
      "INSERT INTO categories (categoryame, category_description) VALUES (?, ?)"
  in
  fun name desc (module Db : Lib_db.T) ->
    Db.exec query (name, desc) |> Lib_db.try_
;;

let test_transaction =
  integration_test
    ~about:"Lib_db.transaction"
    ~desc:
      "when into a transaction, the first succeed and the second one fail, it \
       should rollback the transaction"
    (fun _env db ->
      let open Lwt_util in
      let* task =
        Lib_db.transaction
          (fun () ->
            let*? () = valid_query "foo" "bar" db in
            let*? () = invalid_query "bar" "baz" db in
            return_ok ())
          db
      in
      match task with
      | Ok () -> return_ok (-1, "transaction should fail")
      | Error (Error.Database message) ->
        let*? c = Models.Category.count db in
        return_ok (c, message)
      | _ -> return_ok (-1, "unknown error"))
    (fun computed ->
      let expected =
        Ok
          ( 0
          , "Request to <postgresql://muhokama:_@localhost:5432/muhokama_test> \
             failed: ERROR:  column \"categoryame\" of relation \"categories\" \
             does not exist\n\
             LINE 1: INSERT INTO categories (categoryame, \
             category_description) V...\n\
            \                                ^\n\
            \ Query: \"INSERT INTO categories (categoryame, \
             category_description) VALUES ($1, $2)\"." )
      in
      same (Testable.try_ @@ pair int string) ~expected ~computed)
;;

let cases = "Global", [ test_transaction ]
