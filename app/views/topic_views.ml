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
      ~:Endpoints.Topic.create
      ~csrf_token
      [ category_select categories
      ; topic_title_input
      ; topic_content_input
      ; submit_button
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
