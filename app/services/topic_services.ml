open Lib_common
open Lib_service
open Util
open Middlewares

let get_full_topic request topic_id =
  let open Lwt_util in
  let*? topic = Dream.sql request @@ Models.Topic.get_by_id topic_id in
  let+? messages =
    Dream.sql request @@ Models.Message.get_by_topic_id Fun.id topic_id
  in
  topic, messages
;;

let topic_view ?preview ~request ~user ~topic ~messages () =
  let flash_info = Flash_info.fetch request in
  let csrf_token = Dream.csrf_token request in
  let html_topic = Models.Topic.Showable.map_content markdown_to_html topic in
  let html_messages =
    List.map (Models.Message.map_content markdown_to_html) messages
  in
  Views.Topic.show
    ?flash_info
    ?prefilled:preview
    ~csrf_token
    ~user
    html_topic
    html_messages
;;

let edit_view ?preview ~request ~user ~topic_id ~message () =
  let flash_info = Flash_info.fetch request in
  let csrf_token = Dream.csrf_token request in
  Views.Topic.edit_message
    ?flash_info
    ?preview
    ~csrf_token
    ~user
    topic_id
    message
;;

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

let list_by_category =
  Service.failable_with
    ~:Endpoints.Topic.by_category
    ~attached:user_required
    [ user_authenticated ]
    (fun category user request ->
      let open Lwt_util in
      let+? topics =
        Dream.sql request @@ Models.Topic.list_by_category category Fun.id
      in
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

let edit =
  Service.failable_with
    ~:Endpoints.Topic.edit
    ~attached:user_required
    [ user_authenticated ]
    (fun topic_id user request ->
      let open Lwt_util in
      let+ promise =
        let open Models.Topic in
        let*? previous_topic = Dream.sql request @@ get_by_id topic_id in
        let owner_id = previous_topic.Showable.user_id in
        if Models.User.can_edit ~owner_id user
        then
          let*? categories = Dream.sql request @@ Models.Category.list Fun.id in
          match Preface.Nonempty_list.from_list categories with
          | None -> return Error.(to_try category_absent)
          | Some xs -> return_ok @@ `Editable (user, xs, previous_topic)
        else return_ok @@ `Cant_edit topic_id
      in
      promise |> Result.map_error (fun err -> topic_id, err))
    ~succeed:(fun result request ->
      match result with
      | `Editable (user, categories, previous_topic) ->
        let flash_info = Flash_info.fetch request in
        let csrf_token = Dream.csrf_token request in
        let Models.Topic.Showable.{ category_id; title; content; _ } =
          previous_topic
        in
        let view =
          Views.Topic.edit
            ?flash_info
            ~csrf_token
            ~user
            ~topic_id:previous_topic.id
            ~category_id
            ~title
            ~content
            categories
        in
        Dream.html @@ from_tyxml view
      | `Cant_edit topic_id ->
        redirect_to ~:Endpoints.Topic.show topic_id request)
    ~failure:(fun (topic_id, err) request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Topic.show topic_id request)
;;

let edit_message =
  Service.failable_with
    ~:Endpoints.Topic.edit_message
    ~attached:user_required
    [ user_authenticated ]
    (fun topic_id message_id user request ->
      let open Lwt_util in
      let+ promise =
        let*? previous_message =
          Dream.sql request
          @@ Models.Message.get_by_topic_and_message_id ~topic_id ~message_id
        in
        let can_edit =
          Option.fold
            ~none:false
            ~some:(fun m ->
              let owner_id = m.Models.Message.user_id in
              Models.User.can_edit user ~owner_id)
            previous_message
        in
        match previous_message, can_edit with
        | Some message, true ->
          return_ok @@ `Editable (topic_id, message_id, user, message)
        | _, _ -> return_ok @@ `Cant_edit (topic_id, message_id)
      in
      promise |> Result.map_error (fun err -> topic_id, message_id, err))
    ~succeed:(fun result request ->
      match result with
      | `Editable (topic_id, _message_id, user, message) ->
        let view = edit_view ~request ~user ~topic_id ~message () in
        Dream.html @@ from_tyxml view
      | `Cant_edit (topic_id, _) ->
        redirect_to ~:Endpoints.Topic.show topic_id request)
    ~failure:(fun (topic_id, _, err) request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Topic.show topic_id request)
;;

let save =
  let open Models.Topic in
  Service.failable_with
    ~:Endpoints.Topic.save
    ~attached:user_required
    [ user_authenticated ]
    (fun user request ->
      let open Lwt_util in
      let*? topic = handle_form request validate_creation in
      let title, content = extract_form topic in
      let category_id = created_category topic in
      if is_created_preview topic
      then (
        let current_time = Ptime_clock.now () in
        let*? categories = Dream.sql request @@ Models.Category.list Fun.id in
        let*? categories =
          match Preface.Nonempty_list.from_list categories with
          | None -> return @@ Error.(to_try category_absent)
          | Some xs -> return_ok xs
        in
        let topic =
          Showable.make
            ~id:""
            ~category_id
            ~category_name:""
            ~user_id:user.Models.User.id
            ~user_name:user.Models.User.name
            ~user_email:user.Models.User.email
            ~creation_date:current_time
            ~title
            ~content
        in
        return_ok @@ `Preview_topic (topic, user, categories))
      else
        let*? topic_id = Dream.sql request @@ create user topic in
        let+? () =
          Env.get request @@ Slack_services.new_topic user topic_id title
        in
        `Created_topic topic_id)
    ~succeed:(fun result request ->
      match result with
      | `Created_topic topic_id ->
        Flash_info.action request "Topic enregistré";
        redirect_to ~:Endpoints.Topic.show topic_id request
      | `Preview_topic (topic, user, categories) ->
        let flash_info = Flash_info.fetch request in
        let csrf_token = Dream.csrf_token request in
        let html_topic =
          Models.Topic.Showable.map_content markdown_to_html topic
        in
        let view =
          Views.Topic.create
            ?flash_info
            ~preview:(topic, html_topic)
            ~csrf_token
            ~user
            categories
        in
        Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Topic.create request)
;;

let save_edit =
  Service.failable_with
    ~:Endpoints.Topic.save_edit
    ~attached:user_required
    [ user_authenticated ]
    (fun topic_id user request ->
      let open Lwt_util in
      let open Models.Topic in
      let+ promise =
        let*? previous_topic =
          Dream.sql request @@ Models.Topic.get_by_id topic_id
        in
        if Models.User.can_edit ~owner_id:previous_topic.user_id user
        then
          let*? topic = handle_form request validate_update in
          let+? () = Dream.sql request @@ update topic_id topic in
          `Edited topic_id
        else return_ok @@ `Cant_edit topic_id
      in
      promise |> Result.map_error (fun err -> topic_id, err))
    ~succeed:(fun result request ->
      match result with
      | `Edited topic_id ->
        Flash_info.action request "Topic modifié";
        redirect_to ~:Endpoints.Topic.show topic_id request
      | `Cant_edit topic_id ->
        redirect_to ~:Endpoints.Topic.show topic_id request)
    ~failure:(fun (topic_id, err) request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Topic.edit topic_id request)
;;

let save_edit_message =
  Service.failable_with
    ~:Endpoints.Topic.save_edit_message
    ~attached:user_required
    [ user_authenticated ]
    (fun topic_id message_id user request ->
      let open Lwt_util in
      let open Models.Message in
      let+ promise =
        let*? previous_message =
          Dream.sql request @@ get_by_topic_and_message_id ~topic_id ~message_id
        in
        let can_edit =
          Option.fold
            ~none:false
            ~some:(fun m ->
              let owner_id = m.user_id in
              Models.User.can_edit user ~owner_id)
            previous_message
        in
        if can_edit
        then
          let*? message = handle_form request validate_update in
          if is_updated_preview message
          then (
            let preview_content = updated_message message in
            let current_time = Ptime_clock.now () in
            let message =
              make ~id:message_id ~content:preview_content user current_time
            in
            return_ok @@ `Preview (topic_id, preview_content, user, message))
          else
            let+? () =
              Dream.sql request @@ update ~topic_id ~message_id message
            in
            `Edited (topic_id, message_id)
        else return_ok @@ `Cant_edit (topic_id, message_id)
      in
      promise |> Result.map_error (fun err -> topic_id, message_id, err))
    ~succeed:(fun result request ->
      match result with
      | `Preview (topic_id, raw_content, user, message) ->
        let html_content = markdown_to_html raw_content in
        let view =
          edit_view ~preview:html_content ~request ~user ~topic_id ~message ()
        in
        Dream.html @@ from_tyxml view
      | `Edited (topic_id, message_id) ->
        Flash_info.action request "Message modifié";
        redirect_to ~anchor:message_id ~:Endpoints.Topic.show topic_id request
      | `Cant_edit (topic_id, message_id) ->
        redirect_to ~anchor:message_id ~:Endpoints.Topic.show topic_id request)
    ~failure:(fun (topic_id, message_id, err) request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Topic.edit_message topic_id message_id request)
;;

let show =
  Service.failable_with
    ~:Endpoints.Topic.show
    ~attached:user_required
    [ user_authenticated ]
    (fun topic_id user request ->
      let open Lwt_util in
      let*? topic, messages = get_full_topic request topic_id in
      return_ok (user, topic, messages))
    ~succeed:(fun (user, topic, messages) request ->
      let view = topic_view ~request ~user ~topic ~messages () in
      Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Global.root request)
;;

let answer =
  Service.failable_with
    ~:Endpoints.Topic.answer
    ~attached:user_required
    [ user_authenticated ]
    (fun topic_id user request ->
      let open Lwt_util in
      let open Models.Message in
      let*? message = handle_form request validate_creation in
      if is_created_preview message
      then
        let*? topic, messages = get_full_topic request topic_id in
        let preview_content = created_message message in
        let current_time = Ptime_clock.now () in
        let message_preview =
          make ~id:"" ~content:preview_content user current_time
        in
        let messages = messages @ [ message_preview ] in
        return_ok @@ `Preview (preview_content, user, topic, messages)
      else
        let*? message_id, topic =
          Dream.sql request @@ create user topic_id message
        in
        let+? () =
          Env.get request
          @@ Slack_services.new_answer user topic_id topic message_id
        in
        `Posted (topic_id, message_id))
    ~succeed:(fun result request ->
      match result with
      | `Posted (topic_id, message_id) ->
        Flash_info.action request "Message enregistré";
        redirect_to ~anchor:message_id ~:Endpoints.Topic.show topic_id request
      | `Preview (preview_content, user, topic, messages) ->
        let view =
          topic_view ~preview:preview_content ~request ~user ~topic ~messages ()
        in
        Dream.html @@ from_tyxml view)
    ~failure:(fun err request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Global.root request)
;;

let archive =
  Service.failable_with
    ~:Endpoints.Topic.archive
    ~attached:user_required
    [ user_authenticated ]
    (fun topic_id user request ->
      let open Lwt_util in
      let+ promise =
        if Models.User.can_moderate user
        then
          let*? () = Dream.sql request @@ Models.Topic.archive topic_id in
          return_ok @@ `Moderated
        else
          (* We do not want to display an error
           if the user has no right *)
          return_ok @@ `Cant_moderate topic_id
      in
      promise |> Result.map_error (fun err -> topic_id, err))
    ~succeed:(fun result request ->
      match result with
      | `Cant_moderate topic_id ->
        redirect_to ~:Endpoints.Topic.show topic_id request
      | `Moderated ->
        Flash_info.action request "Topic archivé";
        redirect_to ~:Endpoints.Topic.root request)
    ~failure:(fun (topic_id, err) request ->
      Flash_info.error_tree request err;
      redirect_to ~:Endpoints.Topic.show topic_id request)
;;
