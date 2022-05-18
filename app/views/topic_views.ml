open Lib_common
open Lib_service

module Create = struct
  let category_select categories =
    let open Tyxml.Html in
    let options =
      let open Preface.Nonempty_list in
      map
        (fun category ->
          let open Models.Category in
          option ~a:[ a_value category.id ] @@ txt category.name)
        categories
      |> to_list
    in
    div
      ~a:[ a_class [ "field" ] ]
      [ label
          ~a:[ a_class [ "label" ]; a_label_for "create_topic_category_id" ]
          [ txt "Catégorie dans laquelle créer le fil de conversation" ]
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

  let topic_title_input =
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
                ; a_placeholder "Un titre compréhensif"
                ; a_id "create_topic_title"
                ; a_name "topic_title"
                ; a_class [ "input" ]
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

  let topic_content_input =
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
              (txt "")
          ]
      ]
  ;;

  let submit_button =
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field" ] ]
      [ div
          ~a:[ a_class [ "control" ] ]
          [ input
              ~a:
                [ a_input_type `Submit
                ; a_value "Créer le fil !"
                ; a_class [ "button"; "is-link" ]
                ]
              ()
          ]
      ]
  ;;

  let creation_form csrf_token categories =
    Templates.Util.form
      ~:Endpoints.Topic.save
      ~csrf_token
      [ category_select categories
      ; topic_title_input
      ; topic_content_input
      ; submit_button
      ]
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
              [ txt topic.category_name ]
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
  let show_content user_name user_email creation_date message =
    let open Tyxml.Html in
    (* FIXME: Maybe get rid of Tyxml.Html.Unsafe*)
    let message_html = Omd.of_string message |> Omd.to_html |> Unsafe.data in
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
              [ txt @@ "publié le " ^ Templates.Util.format_date creation_date ]
          ; div
              ~a:[ a_class [ "content"; "is-medium"; "media-content" ] ]
              [ p [ message_html ] ]
          ]
      ]
  ;;

  let message_content_input =
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
              (txt "")
          ]
      ]
  ;;

  let submit_button =
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field" ] ]
      [ div
          ~a:[ a_class [ "control" ] ]
          [ input
              ~a:
                [ a_input_type `Submit
                ; a_value "Répondre au fil !"
                ; a_class [ "button"; "is-link" ]
                ]
              ()
          ]
      ]
  ;;

  let message_form csrf_token user topic =
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
                  ~:Endpoints.Topic.answer
                  ~csrf_token
                  [ message_content_input; submit_button ]
                  topic_id
              ]
          ]
      ]
  ;;

  let topic_content topic =
    let open Tyxml.Html in
    let open Models.Topic.Showable in
    div
      [ div
          ~a:[ a_class [ "columns" ] ]
          [ div
              ~a:[ a_class [ "column"; "is-half" ] ]
              [ h1 ~a:[ a_class [ "title" ] ] [ txt topic.title ] ]
          ; div
              ~a:[ a_class [ "column"; "is-half" ] ]
              [ a
                  ~a:
                    [ a_href "#answer"
                    ; a_class
                        [ "button"
                        ; "is-success"
                        ; "is-medium"
                        ; "is-pulled-right"
                        ]
                    ]
                  [ txt "Répondre au fil" ]
              ]
          ]
      ; show_content
          topic.user_name
          topic.user_email
          topic.creation_date
          topic.content
      ]
  ;;

  let thread csrf_token user topic messages =
    let open Tyxml.Html in
    (topic_content topic
    :: Stdlib.List.map
         (fun message ->
           div
             ~a:[ a_id message.Models.Message.id ]
             [ hr ~a:[ a_class [ "mt-6"; "mb-6" ] ] ()
             ; show_content
                 message.user_name
                 message.user_email
                 message.creation_date
                 message.content
             ])
         messages)
    @ [ message_form csrf_token user topic ]
  ;;
end

let create ?flash_info ~csrf_token ?user categories =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title:"Créer un nouveau topic"
    ?flash_info
    ?user
    Tyxml.Html.[ div [ Create.creation_form csrf_token categories ] ]
;;

let list ?flash_info ?user topics =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title:"Accueil"
    ?flash_info
    ?user
    Tyxml.Html.[ div [ List.all topics ] ]
;;

let show ?flash_info ~csrf_token ~user topic messages =
  let page_title = topic.Models.Topic.Showable.title in
  Templates.Layout.default
    ~lang:"fr"
    ~page_title
    ?flash_info
    ~user
    (Show.thread csrf_token user topic messages)
;;
