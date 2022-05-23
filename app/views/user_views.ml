open Lib_service

module Create = struct
  let user_email_input =
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
                ; a_name "user_email"
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

  let user_name_input =
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
                ; a_name "user_name"
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

  let user_password_input =
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
                ; a_name "user_password"
                ; a_class [ "input" ]
                ]
              ()
          ]
      ; p
          ~a:[ a_class [ "help" ] ]
          [ txt "Au minimum 7 caractères... parce que ce site est sécure." ]
      ]
  ;;

  let confirm_user_password_input =
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field" ] ]
      [ label
          ~a:
            [ a_class [ "label" ]
            ; a_label_for "register_confirm_user_password"
            ]
          [ txt "Confirmation du mot de passe" ]
      ; div
          ~a:[ a_class [ "control" ] ]
          [ input
              ~a:
                [ a_input_type `Password
                ; a_placeholder "azerty123"
                ; a_id "register_confirm_user_password"
                ; a_name "confirm_user_password"
                ; a_class [ "input" ]
                ]
              ()
          ]
      ; p
          ~a:[ a_class [ "help" ] ]
          [ txt
              "Ici il faut réécrire le même mot de passe, c'est juste pour \
               être sur."
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
                ; a_value "Valider !"
                ; a_class [ "button"; "is-link" ]
                ]
              ()
          ]
      ]
  ;;

  let registration_form csrf_token =
    Templates.Util.form
      ~:Endpoints.User.save
      ~csrf_token
      [ user_email_input
      ; user_name_input
      ; user_password_input
      ; confirm_user_password_input
      ; submit_button
      ]
  ;;
end

module Connection = struct
  let user_email_input =
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field"; "mb-4" ] ]
      [ label
          ~a:[ a_class [ "label" ]; a_label_for "connect_user_email" ]
          [ txt "Adresse électronique" ]
      ; div
          ~a:[ a_class [ "control" ] ]
          [ input
              ~a:
                [ a_input_type `Email
                ; a_placeholder "you@domain.com"
                ; a_id "connect_user_email"
                ; a_name "user_email"
                ; a_class [ "input" ]
                ]
              ()
          ]
      ]
  ;;

  let user_password_input =
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "field"; "mb-4" ] ]
      [ label
          ~a:[ a_class [ "label" ]; a_label_for "connect_user_password" ]
          [ txt "Mot de passe" ]
      ; div
          ~a:[ a_class [ "control" ] ]
          [ input
              ~a:
                [ a_input_type `Password
                ; a_placeholder "azerty123"
                ; a_id "connect_user_password"
                ; a_name "user_password"
                ; a_class [ "input" ]
                ]
              ()
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
                ; a_value "Se connecter !"
                ; a_class [ "button"; "is-link" ]
                ]
              ()
          ]
      ]
  ;;

  let connection_form csrf_token =
    Templates.Util.form
      ~:Endpoints.User.auth
      ~csrf_token
      [ user_email_input; user_password_input; submit_button ]
  ;;
end

module List_active = struct
  let user_line user =
    let open Tyxml.Html in
    let Models.User.{ email; name; state; _ } = user in
    tr
      [ td [ txt name ]
      ; td [ txt email ]
      ; td
          ~a:[ a_class [ "has-text-centered" ] ]
          [ Templates.Component.user_state_tag state ]
      ]
  ;;

  let all users =
    let open Tyxml.Html in
    let hd =
      thead
        [ tr
            [ th [ txt "Nom d'utilisateur" ]
            ; th [ txt "Courrier électronique" ]
            ; th ~a:[ a_class [ "has-text-centered" ] ] [ txt "Statut" ]
            ]
        ]
    in
    table
      ~a:[ a_class [ "table"; "is-fullwidth"; "is-striped"; "is-bordered" ] ]
      ~thead:hd
    @@ List.map user_line users
  ;;
end

let create ?flash_info ~csrf_token () =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title:"Créer un compte"
    ?flash_info
    Tyxml.Html.
      [ div
          ~a:[ a_class [ "columns" ] ]
          [ div
              ~a:[ a_class [ "column" ] ]
              [ h1 ~a:[ a_class [ "title" ] ] [ txt "Se créer un compte" ]
              ; Create.registration_form csrf_token
              ]
          ]
      ]
;;

let login ?flash_info ~csrf_token () =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title:"Se connecter"
    ?flash_info
    Tyxml.Html.
      [ div
          ~a:[ a_class [ "columns" ] ]
          [ div
              ~a:[ a_class [ "column" ] ]
              [ h1 ~a:[ a_class [ "title" ] ] [ txt "Se connecter" ]
              ; Connection.connection_form csrf_token
              ]
          ]
      ]
;;

let list_active ?flash_info ?user users () =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title:"Utilisateurs"
    ?flash_info
    ?user
    Tyxml.Html.
      [ div
          ~a:[ a_class [ "columns" ] ]
          [ div
              ~a:[ a_class [ "column"; "is-full" ] ]
              [ h1 ~a:[ a_class [ "title" ] ] [ txt "Utilisateurs actifs" ]
              ; List_active.all users
              ]
          ]
      ]
;;
