open Opium
open Lib_common

let static_css app =
  let local_path = "./assets/css"
  and uri_prefix = "/css" in
  let s = Middleware.static_unix ~local_path ~uri_prefix () in
  app |> App.middleware s |> Lwt.return_ok
;;

let static_images app =
  let local_path = "./assets/images"
  and uri_prefix = "/images" in
  let s = Middleware.static_unix ~local_path ~uri_prefix () in
  app |> App.middleware s |> Lwt.return_ok
;;

type 'a pool = ([< Caqti_error.t ] as 'a) Lib_db.connection

let pool_key_name = "pgsql:pool"
let pool_key_sexp = Sexplib0.Sexp_conv.sexp_of_string pool_key_name

let pool_key : _ pool Rock.Context.key =
  Rock.Context.Key.create (pool_key_name, fun _ -> pool_key_sexp)
;;

let database real_world app =
  let name = "DB connection pool" in
  let open Lwt_util in
  let+? pool = Lib_db.connect_with_env real_world in
  let filter handler request =
    let env = Rock.Context.add pool_key pool request.Rock.Request.env in
    handler Rock.Request.{ request with env }
  in
  let s = Rock.Middleware.create ~name ~filter in
  app |> App.middleware s
;;

let pool request = request.Rock.Request.env |> Rock.Context.get pool_key
let use_pool request query = Lib_db.use (pool request) query
