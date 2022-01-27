open Lib_common
open Lib_crypto

let count_query =
  Caqti_request.find Caqti_type.unit Caqti_type.int
  @@ "SELECT COUNT(*) FROM users"
;;

let count pool =
  let request (module Q : Caqti_lwt.CONNECTION) = Q.find count_query () in
  Lib_db.use pool request
;;

let verify_password password =
  let open Validate in
  let open Assoc.Yojson in
  let message = "min_password_size : 7" in
  password
  |> (string
     & not_blank
     & from_predicate ~message (fun x -> String.length x >= 7))
;;

let hash_password password = Validate.valid @@ Sha256.hash_string password

module Pre_saved = struct
  type t =
    { user_name : string
    ; user_email : string
    ; user_password : Sha256.t
    }

  let make user_name user_email user_password () =
    { user_name; user_email; user_password }
  ;;

  let create yojson_obj =
    let open Validate in
    let open Assoc.Yojson in
    object_and
      (fun obj ->
        make
        <$> required (string & not_blank) "user_name" obj
        <*> required (string & is_email) "user_email" obj
        <*> required (verify_password & hash_password) "user_password" obj
        <*> ensure_equality "user_password" "confirm_user_password" obj)
      yojson_obj
    |> run ~provider:"User.Pre_saved"
  ;;

  let save_query =
    Caqti_request.exec
      Caqti_type.(tup3 string string string)
      "INSERT INTO users (user_name, user_email, user_password) VALUES (?, ?, \
       ?)"
  ;;

  let save pool { user_name; user_email; user_password } =
    let request (module Q : Caqti_lwt.CONNECTION) =
      Q.exec save_query (user_name, user_email, Sha256.to_string user_password)
    in
    Lib_db.use pool request
  ;;
end
