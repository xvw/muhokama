open Lib_common
open Lib_service
open Util
open Middlewares

let list =
  Service.failable_with
    ~:Endpoints.Category.list
    [user_authenticated]
    ~attached:user_required
    (fun user request ->
      let open Lwt_util in
      let+? categories = Dream.sql request @@ Models.Category.list Fun.id in
      user, categories)
    ~succeed:(fun (user, categories) request ->
      let flash_info = Util.Flash_info.fetch request in
      let view = Views.Category.categories ?flash_info categories ~user:user in
      Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Global.root request)