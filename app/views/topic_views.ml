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
              ~a:
                [ a_class [ "tag"; "is-info"; "is-medium"; "is-pulled-right" ] ]
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
  let topic_content topic =
    let open Tyxml.Html in
    let open Models.Topic.Showable in
    let message_content = topic.content in
    (* FIXME: Maybe get rid of Tyxml.Html.Unsafe*)
    let message_html =
      Omd.of_string message_content |> Omd.to_html |> Unsafe.data
    in
    let src = Gravatar.(url ~default:Identicon ~size:72 topic.user_email) in
    let alt = "Avatar of " ^ topic.user_name in
    div
      [ h1 ~a:[ a_class [ "title" ] ] [ txt topic.title ]
      ; div
          ~a:[ a_class [ "media" ] ]
          [ div
              ~a:[ a_class [ "media-left" ] ]
              [ img ~a:[ a_class [ "image" ] ] ~src ~alt () ]
          ; div
              ~a:[ a_class [ "media-content" ] ]
              [ p
                  ~a:[ a_class [ "title"; "is-6" ] ]
                  [ txt @@ "@" ^ topic.user_name ]
              ; p
                  ~a:[ a_class [ "subtitle"; "is-6" ] ]
                  [ txt
                    @@ "publié le "
                    ^ Templates.Util.format_date topic.creation_date
                  ]
              ; div
                  ~a:[ a_class [ "content"; "is-medium"; "media-content" ] ]
                  [ p [ message_html ] ]
              ]
          ]
      ]
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

let show ?flash_info ?user topic =
  let page_title = topic.Models.Topic.Showable.title in
  Templates.Layout.default
    ~lang:"fr"
    ~page_title
    ?flash_info
    ?user
    [ Show.topic_content topic ]
;;
