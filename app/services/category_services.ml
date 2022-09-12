open Lib_common
open Lib_service
open Util
open Middlewares

let topics_count_by_categories =
  Service.failable_with
    ~:Endpoints.Category.list
    [ user_authenticated ]
    ~attached:user_required
    (fun user request ->
      let open Lwt_util in
      let+? count_topics_by_categories =
        Dream.sql request @@ Models.Topic.count_by_categories
      in
      user, count_topics_by_categories)
    ~succeed:(fun (user, count_topics_by_categories) request ->
      let flash_info = Util.Flash_info.fetch request in
      let view =
        Views.Category.by_topics_count
          ?flash_info
          ~user
          count_topics_by_categories
      in
      Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Global.root request)
;;
