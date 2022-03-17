let new_user_email_input =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "field" ] ]
    [ label
        ~a:[ a_class [ "label" ]; a_label_for "register_user_email" ]
        [ txt "Adresse électronique" ]
    ; div
        ~a:[ a_class [ "control" ] ]
        [ input
            ~a:
              [ a_input_type `Email
              ; a_placeholder "you@domain.com"
              ; a_id "register_user_email"
              ; a_name Model.User.For_registration.user_email_key
              ; a_class [ "input" ]
              ]
            ()
        ]
    ; p
        ~a:[ a_class [ "help" ] ]
        [ txt "Il faut que l'adresse ressemble à une adresse mail."
        ; br ()
        ; txt "C'est l'adresse qui fera office d'identifiant sur le site."
        ]
    ]
;;

let new_user_name_input =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "field" ] ]
    [ label
        ~a:[ a_class [ "label" ]; a_label_for "register_user_name" ]
        [ txt "Nom d'utilisateur" ]
    ; div
        ~a:[ a_class [ "control" ] ]
        [ input
            ~a:
              [ a_input_type `Text
              ; a_placeholder "J. Doe"
              ; a_id "register_user_name"
              ; a_name Model.User.For_registration.user_name_key
              ; a_class [ "input" ]
              ]
            ()
        ]
    ; p
        ~a:[ a_class [ "help" ] ]
        [ txt
            "C'est un nom d'affichage, donc il faut que ça ait l'air un peu \
             sérieux."
        ]
    ]
;;

let new_user_password_input =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "field" ] ]
    [ label
        ~a:[ a_class [ "label" ]; a_label_for "register_user_password" ]
        [ txt "Mot de passe" ]
    ; div
        ~a:[ a_class [ "control" ] ]
        [ input
            ~a:
              [ a_input_type `Password
              ; a_placeholder "azerty123"
              ; a_id "register_user_password"
              ; a_name Model.User.For_registration.user_password_key
              ; a_class [ "input" ]
              ]
            ()
        ]
    ; p
        ~a:[ a_class [ "help" ] ]
        [ txt "Au minimum 7 caractères... parce que ce site est sécure." ]
    ]
;;

let new_confirm_user_password_input =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "field" ] ]
    [ label
        ~a:[ a_class [ "label" ]; a_label_for "register_confirm_user_password" ]
        [ txt "Confirmation du mot de passe" ]
    ; div
        ~a:[ a_class [ "control" ] ]
        [ input
            ~a:
              [ a_input_type `Password
              ; a_placeholder "azerty123"
              ; a_id "register_confirm_user_password"
              ; a_name Model.User.For_registration.confirm_user_password_key
              ; a_class [ "input" ]
              ]
            ()
        ]
    ; p
        ~a:[ a_class [ "help" ] ]
        [ txt
            "Ici il faut réécrire le même mot de passe, c'est juste pour être \
             sur."
        ]
    ]
;;

let new_submit_button =
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

let new_form csrf_token =
  let open Tyxml.Html in
  form
    ~a:[ a_method `Post; a_action "/user/new" ]
    [ Template.Util.csrf_input csrf_token
    ; new_user_email_input
    ; new_user_name_input
    ; new_user_password_input
    ; new_confirm_user_password_input
    ; new_submit_button
    ]
;;

let create ?flash_info ~csrf_token () =
  Template.Layout.default
    ~lang:"en"
    ~page_title:"Créer un compte"
    ?flash_info
    Tyxml.Html.
      [ div
          ~a:[ a_class [ "columns" ] ]
          [ div
              ~a:[ a_class [ "column"; "is-half" ] ]
              [ h1 ~a:[ a_class [ "title" ] ] [ txt "Se créer un compte" ]
              ; new_form csrf_token
              ]
          ]
      ]
;;
