open Lib_common
open Lib_service
open Util
open Middlewares

let list =
  Service.failable_with
    ~:Endpoints.Topic.root
    ~attached:user_required
    [ user_authenticated ]
    (fun user request ->
      let open Lwt_util in
      let+? topics = Dream.sql request @@ Models.Topic.list_all Fun.id in
      user, topics)
    ~succeed:(fun (user, topics) request ->
      let flash_info = Flash_info.fetch request in
      let view = Views.Topic.list ?flash_info ~user topics in
      Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Global.error request)
;;

let create =
  Service.failable_with
    ~:Endpoints.Topic.create
    ~attached:user_required
    [ user_authenticated ]
    (fun user request ->
      let open Lwt_util in
      let+ categories = Dream.sql request @@ Models.Category.list Fun.id in
      Result.bind categories (fun categories ->
          match Preface.Nonempty_list.from_list categories with
          | None -> Error.(to_try category_absent)
          | Some xs -> Ok (user, xs)))
    ~succeed:(fun (user, categories) request ->
      let flash_info = Flash_info.fetch request in
      let csrf_token = Dream.csrf_token request in
      let view = Views.Topic.create ?flash_info ~csrf_token ~user categories in
      Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Global.root request)
;;

let save =
  Service.failable_with
    ~:Endpoints.Topic.save
    ~attached:user_required
    [ user_authenticated ]
    (fun user request ->
      let open Lwt_util in
      let open Models.Topic in
      let*? topic = handle_form request validate_creation in
      Dream.sql request @@ create user topic)
    ~succeed:(fun topic_id request ->
      Flash_info.action request "Topic enregistré";
      redirect_to ~:Endpoints.Topic.show topic_id request)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Topic.create request)
;;

let show =
  Service.failable_with
    ~:Endpoints.Topic.show
    ~attached:user_required
    [ user_authenticated ]
    (fun topic_id user request ->
      let open Lwt_util in
      let+? topic = Dream.sql request @@ Models.Topic.get_by_id topic_id in
      user, topic)
    ~succeed:(fun (user, topic) request ->
      let flash_info = Flash_info.fetch request in
      let view = Views.Topic.show ?flash_info ~user topic in
      Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Global.root request)
;;
