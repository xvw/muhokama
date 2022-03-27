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
  Model.User.validate_registration
    [ "user_name", name
    ; "user_email", mail
    ; "user_password", pass
    ; "confirm_user_password", confirm
    ]
;;

let make_user ?(state = Model.User.State.Inactive) name mail pass db =
  let open Lwt_util in
  let*? r = return @@ user_for_registration name mail pass pass in
  let*? () = Model.User.register r db in
  let*? { id = user_id; _ } = Model.User.get_by_email mail db in
  let*? () = Model.User.change_state ~user_id state db in
  Model.User.get_by_email mail db
;;

let user_for_connection mail pass =
  Model.User.validate_connection [ "user_email", mail; "user_password", pass ]
;;
