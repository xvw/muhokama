open Lib_common
open Lib_service

module Create = struct
  let category_select categories category_id =
    let open Tyxml.Html in
    let options =
      Preface.Nonempty_list.map
        (fun category ->
          let open Models.Category in
          let selected =
            if category_id
               |> Option.map (fun x -> x = category.id)
               |> Option.value ~default:false
            then [ a_selected () ]
            else []
          in
          option ~a:([ a_value category.id ] @ selected) @@ txt category.name)
        categories
      |> Preface.Nonempty_list.to_list
    in
    div
      ~a:[ a_class [ "field" ] ]
      [ label
          ~a:[ a_class [ "label" ]; a_label_for "create_topic_category_id" ]
          [ (if Option.is_none category_id
            then txt "Catégorie dans laquelle créer le fil de conversation"
            else txt "Catégorie du fil de conversation")
          ]
      ; div
          ~a:[ a_class [ "control" ] ]
          [ div
              ~a:[ a_class [ "select"; "is-large"; "is-fullwidth" ] ]
              [ select
                  ~a:[ a_id "create_topic_category_id"; a_name "category_id" ]
                  options
              ]
          ]
      ]
  ;;

  let topic_title_input title =
    let title_value = Option.value ~default:"" title in
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field" ] ]
      [ label
          ~a:[ a_class [ "label" ]; a_label_for "create_topic_title" ]
          [ txt "Titre du topic" ]
      ; div
          ~a:[ a_class [ "control" ] ]
          [ input
              ~a:
                [ a_input_type `Text
                ; a_placeholder "Un titre compréhensible"
                ; a_id "create_topic_title"
                ; a_name "topic_title"
                ; a_class [ "input" ]
                ; a_value title_value
                ]
              ()
          ]
      ; p
          ~a:[ a_class [ "help" ] ]
          [ txt
              "Essayez de trouver un titre clair qui indique rapidement la \
               thématique du fil de conversation."
          ]
      ]
  ;;

  let topic_content_input content =
    let content_value = Option.value ~default:"" content in
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field" ] ]
      [ label
          ~a:[ a_class [ "label" ]; a_label_for "create_topic_content" ]
          [ txt "Contenu du message" ]
      ; div
          ~a:[ a_class [ "control" ] ]
          [ textarea
              ~a:
                [ a_placeholder "Ecrivez ici votre message (en Markdown) ..."
                ; a_id "create_topic_content"
                ; a_rows 15
                ; a_name "topic_content"
                ; a_class [ "textarea"; "is-large" ]
                ]
              (txt content_value)
          ]
      ]
  ;;

  let submit_buttons topic_id =
    let button_msg =
      if Option.is_none topic_id then "Créer le fil" else "Modifier le message"
    in
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field" ] ]
      [ div
          ~a:[ a_class [ "control" ] ]
          [ input
              ~a:
                [ a_input_type `Submit
                ; a_name "Preview"
                ; a_value "Prévisualiser le message"
                ; a_class [ "button"; "is-link" ]
                ]
              ()
          ; input
              ~a:
                [ a_input_type `Submit
                ; a_name "Submit"
                ; a_value button_msg
                ; a_class [ "button"; "is-link" ]
                ]
              ()
          ]
      ]
  ;;

  let creation_form
    ?topic_id
    ?pre_category_id
    ?pre_title
    ?pre_content
    csrf_token
    categories
    =
    let params =
      [ category_select categories pre_category_id
      ; topic_title_input pre_title
      ; topic_content_input pre_content
      ; submit_buttons topic_id
      ]
    in
    let form =
      Option.fold
        ~none:(fun () ->
          Templates.Util.form ~:Endpoints.Topic.save ~csrf_token params)
        ~some:(fun topic_id () ->
          Templates.Util.form
            ~:Endpoints.Topic.save_edit
            ~csrf_token
            params
            topic_id)
        topic_id
    in
    form ()
  ;;
end

module List = struct
  let line topic =
    let open Tyxml.Html in
    let open Models.Topic.Listable in
    let src = Gravatar.(url ~default:Identicon ~size:48 topic.user_email) in
    let alt = "Avatar of " ^ topic.user_name in
    let responses_suffix = if topic.responses > 1 then "s" else "" in
    let responses = Fmt.str "%d réponse%s" topic.responses responses_suffix in
    tr
      [ td
          ~a:[ a_class [ "is-vcentered" ] ]
          [ img ~a:[ a_class [ "image"; "is-48x48" ] ] ~src ~alt () ]
      ; td
          ~a:[ a_class [ "is-vcentered"; "is-fullwidth" ] ]
          [ Templates.Util.a ~:Endpoints.Topic.show [ txt topic.title ] topic.id
          ]
      ; td
          ~a:[ a_class [ "is-vcentered" ] ]
          [ span ~a:[ a_class [ "is-pulled-right" ] ] [ txt responses ] ]
      ; td
          ~a:[ a_class [ "is-vcentered" ] ]
          [ Templates.Util.a
              ~:Endpoints.Topic.by_category
              ~a:[ a_class [ "button"; "is-info"; "is-pulled-right" ] ]
              [ txt @@ Lib_common.Html.escape_special_chars topic.category_name
              ]
              topic.category_name
          ]
      ]
  ;;

  let all topics =
    let open Tyxml.Html in
    table
      ~a:
        [ a_class
            [ "table"; "is-fullwidth"; "is-stripped"; "content"; "is-medium" ]
        ]
    @@ List.map line topics
  ;;
end

module Show = struct
  let edition_link kind current_user user_id id =
    let open Tyxml.Html in
    if Models.User.can_edit ~owner_id:user_id current_user
       && id <> "" (* Previewed messages have no edit link *)
    then (
      match kind with
      | `Topic ->
        Templates.Util.a
          ~:Endpoints.Topic.edit
          ~a:[ a_class [ "pl-4" ] ]
          [ txt "Éditer" ]
          id
      | `Message t_id ->
        Templates.Util.a
          ~:Endpoints.Topic.edit_message
          ~a:[ a_class [ "pl-4" ] ]
          [ txt "Éditer" ]
          t_id
          id
      | `Preview -> span [])
    else span []
  ;;

  let show_content
    kind
    current_user
    user_id
    user_name
    user_email
    id
    creation_date
    message
    =
    let open Tyxml.Html in
    (* FIXME: Maybe get rid of Tyxml.Html.Unsafe*)
    let message_html = Unsafe.data message in
    div
      ~a:[ a_class [ "media" ] ]
      [ div
          ~a:[ a_class [ "media-left" ] ]
          [ Templates.Component.avatar ~email:user_email ~username:user_name ()
          ]
      ; div
          ~a:[ a_class [ "media-content" ] ]
          [ p ~a:[ a_class [ "title"; "is-6" ] ] [ txt @@ "@" ^ user_name ]
          ; p
              ~a:[ a_class [ "subtitle"; "is-6" ] ]
              [ span
                  [ txt
                    @@ "publié le "
                    ^ Templates.Util.format_date creation_date
                  ]
              ; edition_link kind current_user user_id id
              ]
          ; div
              ~a:[ a_class [ "content"; "is-medium"; "media-content" ] ]
              [ p [ message_html ] ]
          ]
      ]
  ;;

  let message_content_input ?(message_content = "") () =
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field" ] ]
      [ div
          ~a:[ a_class [ "control" ] ]
          [ textarea
              ~a:
                [ a_placeholder "Ecrivez ici votre message (en Markdown) ..."
                ; a_id "create_topic_content"
                ; a_rows 8
                ; a_name "message_content"
                ; a_class [ "textarea"; "is-large" ]
                ]
              (txt message_content)
          ]
      ]
  ;;

  let submit_buttons kind =
    let message =
      match kind with
      | `Answer -> "Répondre au fil !"
      | `Edit -> "Éditer le message !"
    in
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field" ] ]
      [ div
          ~a:[ a_class [ "control" ] ]
          [ input
              ~a:
                [ a_input_type `Submit
                ; a_name "Preview"
                ; a_value "Prévisualiser le message !"
                ; a_class [ "button"; "is-link" ]
                ]
              ()
            (* TODO: space between buttons? *)
          ; input
              ~a:
                [ a_input_type `Submit
                ; a_name "Answer"
                ; a_value message
                ; a_class [ "button"; "is-link" ]
                ]
              ()
          ]
      ]
  ;;

  let message_form ?(prefilled = "") csrf_token user topic =
    let open Tyxml.Html in
    let topic_id = topic.Models.Topic.Showable.id in
    div
      [ h2 ~a:[ a_class [ "title"; "mt-6" ] ] [ txt "Composer une réponse" ]
      ; div
          ~a:[ a_class [ "media" ]; a_id "answer" ]
          [ div
              ~a:[ a_class [ "media-left" ] ]
              [ Templates.Component.avatar
                  ~email:user.Models.User.email
                  ~username:user.name
                  ()
              ]
          ; div
              ~a:[ a_class [ "media-content" ] ]
              [ Templates.Util.form
                  ~anchor:"answer"
                  ~:Endpoints.Topic.answer
                  ~csrf_token
                  [ message_content_input ~message_content:prefilled ()
                  ; submit_buttons `Answer
                  ]
                  topic_id
              ]
          ]
      ]
  ;;

  let archive_button user topic =
    if Models.User.can_moderate user
    then
      let open Tyxml.Html in
      [ Templates.Util.a
          ~:Endpoints.Topic.archive
          ~a:
            [ a_href "#answer"; a_class [ "button"; "is-danger"; "is-medium" ] ]
          [ txt "Archiver" ]
          topic.Models.Topic.Showable.id
      ]
    else []
  ;;

  let topic_content ?(show_buttons = true) user topic =
    let open Tyxml.Html in
    let open Models.Topic.Showable in
    let answer_button =
      a
        ~a:[ a_href "#answer"; a_class [ "button"; "is-success"; "is-medium" ] ]
        [ txt "Répondre au fil" ]
    in
    div
      [ div
          ~a:[ a_class [ "columns" ] ]
          [ div
              ~a:[ a_class [ "column" ] ]
              [ h1 ~a:[ a_class [ "title" ] ] [ txt topic.title ] ]
          ; div
              ~a:[ a_class [ "column"; "is-narrow"; "is-hidden-mobile" ] ]
              (if show_buttons
              then answer_button :: archive_button user topic
              else [])
          ]
      ; show_content
          `Topic
          user
          topic.user_id
          topic.user_name
          topic.user_email
          topic.id
          topic.creation_date
          topic.content
      ]
  ;;

  let thread ?prefilled csrf_token user topic messages =
    let open Tyxml.Html in
    (topic_content user topic
    :: Stdlib.List.map
         (fun message ->
           div
             ~a:
               (a_id message.Models.Message.id
               :: (if message.id = "" then [ a_class [ "preview" ] ] else []))
             [ hr ~a:[ a_class [ "mt-6"; "mb-6" ] ] ()
             ; show_content
                 (`Message topic.id)
                 user
                 message.user_id
                 message.user_name
                 message.user_email
                 message.id
                 message.creation_date
                 message.content
             ])
         messages)
    @ [ message_form ?prefilled csrf_token user topic ]
  ;;
end

module Message = struct
  let edit ?preview csrf_token user topic_id message =
    let open Tyxml.Html in
    let open Models.Message in
    let avatar =
      div
        ~a:[ a_class [ "media-left" ] ]
        [ Templates.Component.avatar
            ~email:message.user_email
            ~username:message.user_name
            ()
        ]
    in
    let preview =
      match preview with
      | None -> []
      | Some raw_content ->
        [ div
            ~a:[ a_id message.Models.Message.id ]
            [ hr ~a:[ a_class [ "mt-6"; "mb-6" ] ] ()
            ; Show.show_content
                `Preview
                user
                message.user_id
                message.user_name
                message.user_email
                message.id
                message.creation_date
                raw_content
            ; hr ~a:[ a_class [ "mt-6"; "mb-6" ] ] ()
            ]
        ]
    in
    let message_ctn =
      Show.message_content_input ~message_content:message.content ()
    in
    [ div
        ((if user.Models.User.id <> message.user_id
         then
           [ Templates.Component.flash_info
               (Some
                  (Models.Flash_info.Info
                     "Vous allez modifier un contenu dont vous n'êtes pas le \
                      propriétaire"))
           ]
         else [])
        @ preview
        @ [ h2 ~a:[ a_class [ "title"; "mt-6" ] ] [ txt "Éditer le message" ]
          ; div
              ~a:[ a_class [ "media" ]; a_id "answer" ]
              [ avatar
              ; div
                  ~a:[ a_class [ "media-content" ] ]
                  [ Templates.Util.form
                      ~:Endpoints.Topic.save_edit_message
                      ~csrf_token
                      [ message_ctn; Show.submit_buttons `Edit ]
                      topic_id
                      message.id
                  ]
              ]
          ])
    ]
  ;;
end

let topic_form
  ?flash_info
  ?preview
  ~csrf_token
  ~user
  ?topic_id
  ?pre_category_id
  ?pre_title
  ?pre_content
  categories
  =
  let open Tyxml.Html in
  let page_title =
    if Option.is_none topic_id
    then "Créer un nouveau topic"
    else "Éditer un message"
  in
  let preview =
    match preview with
    | None -> div []
    | Some topic -> div [ Show.topic_content ~show_buttons:false user topic ]
  in
  Templates.Layout.default
    ~lang:"fr"
    ~page_title
    ~user
    ?flash_info
    [ preview
    ; div
        [ Create.creation_form
            ?pre_category_id
            ?pre_title
            ?pre_content
            ?topic_id
            csrf_token
            categories
        ]
    ]
;;

(* FIXME: this is very complicated. The issue is twofold:
  - the views dependencies are very ad-hoc themselves
  - Showable.t.content can contain both markdown and the resulting HTML code *)
let create ?flash_info ?preview ~csrf_token ~user categories =
  let (pre_title, pre_content, pre_category_id), preview =
    Option.fold
      ~none:((None, None, None), None)
      ~some:(fun (topic, html_topic) ->
        let open Models.Topic.Showable in
        ( (Some topic.title, Some topic.content, Some topic.category_id)
        , Some html_topic ))
      preview
  in
  topic_form
    ?flash_info
    ?preview
    ?pre_title
    ?pre_content
    ?pre_category_id
    ~csrf_token
    ~user
    categories
;;

let edit
  ?flash_info
  ?preview
  ~csrf_token
  ~user
  ~topic_id
  ~category_id
  ~title
  ~content
  categories
  =
  let preview = Option.map snd preview in
  topic_form
    ?flash_info
    ?preview
    ~csrf_token
    ~user
    ~topic_id
    ~pre_category_id:category_id
    ~pre_title:title
    ~pre_content:content
    categories
;;

let list ?flash_info ?user topics =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title:"Accueil"
    ?flash_info
    ?user
    Tyxml.Html.[ div [ List.all topics ] ]
;;

let show ?flash_info ?prefilled ~csrf_token ~user topic messages =
  let page_title = topic.Models.Topic.Showable.title in
  Templates.Layout.default
    ~lang:"fr"
    ~page_title
    ?flash_info
    ~user
    (Show.thread ?prefilled csrf_token user topic messages)
;;

let edit_message ?flash_info ?preview ~csrf_token ~user topic_id message =
  let page_title = "Éditer un message" in
  Templates.Layout.default
    ~lang:"fr"
    ~page_title
    ?flash_info
    ~user
    (Message.edit ?preview csrf_token user topic_id message)
;;
