open Lib_common
module Testable = Testable

let test ?(speed = `Quick) ~about ~desc f =
  Alcotest.test_case (Format.asprintf "%-42s%s" about desc) speed f
;;

let integration_test
  ?(migrations_path = "../../../../migrations")
  ?(speed = `Slow)
  ~about
  ~desc
  f
  e
  =
  test ~speed ~about ~desc (fun () ->
    let promise =
      let open Lwt_util in
      let*? env = Env.init () in
      let*? pool = Lib_db.connect env in
      Lib_db.use pool (fun db ->
        let open Lib_migration in
        let*? () = Migrate.run migrations_path (Some 0) db in
        let*? () = Migrate.run migrations_path None db in
        let+? result = f env db in
        db, result)
    in
    match Lwt_main.run promise with
    | Error err -> e (Error err)
    | Ok (db, result) ->
      let _ =
        Lwt_main.run @@ Lib_migration.Migrate.run migrations_path (Some 0) db
      in
      e (Ok result))
;;

let same testable ~expected ~computed =
  Alcotest.check testable "should be same" expected computed
;;

let nel x xs =
  let open Preface.Nonempty_list in
  match from_list xs with
  | None -> Last x
  | Some xs -> x :: xs
;;

module Individual = struct
  type t =
    { id : string
    ; age : int option
    ; name : string option
    ; email : string
    }

  let pp ppf { id; age; name; email } =
    Format.fprintf
      ppf
      "%s;%a;%a;%s"
      id
      Fmt.(option int)
      age
      Fmt.(option string)
      name
      email
  ;;

  let equal a b =
    String.equal a.id b.id
    && Option.equal Int.equal a.age b.age
    && Option.equal String.equal a.name b.name
    && String.equal a.email b.email
  ;;

  let testable = Alcotest.testable pp equal
  let make id age name email = { id; age; name; email }
end

let user_for_registration name mail pass confirm =
  Models.User.validate_registration
    [ "user_name", name
    ; "user_email", mail
    ; "user_password", pass
    ; "confirm_user_password", confirm
    ]
;;

let category_for_creation name desc =
  Models.Category.validate_creation
    [ "category_name", name; "category_description", desc ]
;;

let make_user ?(state = Models.User.State.Inactive) name mail pass db =
  let open Lwt_util in
  let*? r = return @@ user_for_registration name mail pass pass in
  let*? () = Models.User.register r db in
  let*? { id = user_id; _ } = Models.User.get_by_email mail db in
  let*? () = Models.User.change_state ~user_id state db in
  Models.User.get_by_email mail db
;;

let user_for_connection mail pass =
  Models.User.validate_connection [ "user_email", mail; "user_password", pass ]
;;

let topic_for_creation category_id title content =
  Models.Topic.validate_creation
    [ "category_id", category_id
    ; "topic_title", title
    ; "topic_content", content
    ]
;;

let topic_for_modification category_id title content =
  Models.Topic.validate_update
    [ "category_id", category_id
    ; "topic_title", title
    ; "topic_content", content
    ]
;;

let message_for_creation message_content =
  Models.Message.validate_creation [ "message_content", message_content ]
;;

let create_category name desc db =
  let open Lwt_util in
  let*? c = Lwt.return @@ category_for_creation name desc in
  Models.Category.create c db
;;

let create_topic category_id user title content db =
  let open Lwt_util in
  let*? t = Lwt.return @@ topic_for_creation category_id title content in
  Models.Topic.create user t db
;;

let update_topic topic_id category_id title content db =
  let open Lwt_util in
  let*? t = Lwt.return @@ topic_for_modification category_id title content in
  Models.Topic.update topic_id t db
;;

let create_message user topic_id content db =
  let open Lwt_util in
  let*? t = Lwt.return @@ message_for_creation content in
  Models.Message.create user topic_id t db
;;

let create_categories db =
  let open Lwt_util in
  let*? () = create_category "general" "general purpose" db in
  let*? () = create_category "programming" "programming purpose" db in
  let*? () = create_category "muhokama" "about muhokama" db in
  let*? general = Models.Category.get_by_name "general" db in
  let*? programming = Models.Category.get_by_name "programming" db in
  let*? muhokama = Models.Category.get_by_name "muhokama" db in
  Lwt.return_ok (general, programming, muhokama)
;;

let create_users db =
  let open Lwt_util in
  let*? grim =
    make_user
      ~state:Models.User.State.Moderator
      "grim"
      "grim@muhokama.com"
      "grimpwd12345"
      db
  in
  let*? xhtmlboy =
    make_user
      ~state:Models.User.State.Moderator
      "xhtmlboy"
      "xhmlboy@muhokama.com"
      "xhtmlboypwd12345"
      db
  in
  let*? xvw =
    make_user
      ~state:Models.User.State.Admin
      "xvw"
      "xvw@muhokama.com"
      "xvwpwd12345"
      db
  in
  let*? dplaindoux =
    make_user
      ~state:Models.User.State.Moderator
      "dplaindoux"
      "dplaindoux@muhokama.com"
      "dplaindouxpwd12345"
      db
  in
  Lwt.return_ok (grim, xhtmlboy, xvw, dplaindoux)
;;
