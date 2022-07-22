open Lib_service

let category_name_input =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "field" ] ]
    [ label
        ~a:[ a_class [ "label" ]; a_label_for "create_category_name" ]
        [ txt "Nom de la catégorie" ]
    ; div
        ~a:[ a_class [ "control" ] ]
        [ input
            ~a:
              [ a_input_type `Text
              ; a_placeholder "programmation"
              ; a_id "create_category_name"
              ; a_name "category_name"
              ; a_class [ "input" ]
              ]
            ()
        ]
    ; p
        ~a:[ a_class [ "help" ] ]
        [ txt
            "Nom de la catégorie, choisissez quelque chose de concis mais \
              clair !"
        ]
    ]
;;

let category_description_input =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "field" ] ]
    [ label
        ~a:[ a_class [ "label" ]; a_label_for "create_category_description" ]
        [ txt "Description de la catégorie" ]
    ; div
        ~a:[ a_class [ "control" ] ]
        [ textarea
            ~a:
              [ a_placeholder
                  "Catégorie relative aux conversations concernant la \
                    programmation"
              ; a_id "create_category_description"
              ; a_name "category_description"
              ; a_class [ "textarea"; "is-small" ]
              ]
            (txt "")
        ]
    ; p
        ~a:[ a_class [ "help" ] ]
        [ txt "Choisissez une description concise mais claire !" ]
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
              ; a_value "Valider !"
              ; a_class [ "button"; "is-link" ]
              ]
            ()
        ]
    ]
;;

let creation_form csrf_token =
  Templates.Util.form
    ~:Endpoints.Admin.new_category
    ~csrf_token
    [ category_name_input; category_description_input; submit_button ]
;;

let category_line category =
  let open Tyxml.Html in
  let open Models.Category in
  tr [ td [ txt category.name ]; td [ txt category.description ] ]
;;

let all categories =
  let open Tyxml.Html in
  let hd = thead [ tr [ th [ txt "Nom" ]; th [ txt "Description" ] ] ] in
  table
    ~a:
      [ a_class
          [ "table"
          ; "is-fullwidth"
          ; "is-narrow"
          ; "is-striped"
          ; "is-bordered"
          ]
      ]
    ~thead:hd
  @@ List.map category_line categories
;;

let by_topic_count_line (name, desc, counter) =
  let open Tyxml.Html in
  tr [ 
    td [ 
      p ~a:[a_class ["title is-4"]] [ txt name ];
      p ~a:[a_class ["subtitle"]] [ txt desc ]
    ]; 
    td [
    if counter > 0 then
        Templates.Util.a 
          ~:Endpoints.Topic.by_category [txt (string_of_int counter)] name
    else
      txt (string_of_int counter)
    ]
  ]



let by_topics_count ?flash_info ?user cnt_topics_by_categories =
  let open Tyxml.Html in
  let hd = thead [ tr [ th [ txt "Catégories" ]; th [ txt "Nombre de topics" ] ] ] in
  Templates.Layout.default
    ?flash_info
    ?user
    ~lang:"fr"
    ~page_title:"Catégories"
    Tyxml.Html.
      [
        div ~a:[ a_class [ "mb-2" ] ]
          [
            div ~a:[ a_class [ "content" ] ]
              [
                table
                ~thead: hd
                @@ List.map by_topic_count_line cnt_topics_by_categories
              ]
          ]
      ]