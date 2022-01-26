let count_query =
  Caqti_request.find Caqti_type.unit Caqti_type.int
  @@ "SELECT COUNT(*) FROM users"
;;

let count pool =
  let request (module Q : Caqti_lwt.CONNECTION) = Q.find count_query () in
  Lib_db.use pool request
;;
