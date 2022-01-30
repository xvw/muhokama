open Tyxml

let dummy ?(notifs = Notif.Nothing) () =
  Template.page
    ~notifs
    ~lang:"en"
    ~page_title:"A dummy page"
    Html.[ txt "Hello world" ]
;;

let register ?(notifs = Notif.Nothing) () =
  let user_name, user_email, user_password, confirm_user_password =
    Lib_model.User.Pre_saved.formlet
  in
  Template.page
    ~notifs
    ~lang:"fr"
    ~page_title:"Créer un compte"
    Html.
      [ div
          ~a:[ a_class [ "columns" ] ]
          [ div
              ~a:[ a_class [ "column"; "is-half" ] ]
              [ h1 ~a:[ a_class [ "title" ] ] [ txt "Se créer un compte" ]
              ; form
                  ~a:[ a_method `Post; a_action "/register/new" ]
                  [ div
                      ~a:[ a_class [ "field" ] ]
                      [ label
                          ~a:
                            [ a_class [ "label" ]
                            ; a_label_for "register_user_name"
                            ]
                          [ txt "Adresse électronique" ]
                      ; div
                          ~a:[ a_class [ "control" ] ]
                          [ input
                              ~a:
                                [ a_input_type @@ snd user_email
                                ; a_placeholder "you@domain.com"
                                ; a_id "register_user_email"
                                ; a_name @@ fst user_email
                                ; a_class [ "input" ]
                                ]
                              ()
                          ]
                      ; p
                          ~a:[ a_class [ "help" ] ]
                          [ txt
                              "Il faut que l'adresse ressemble à une adresse \
                               mail."
                          ; br ()
                          ; txt
                              "C'est l'adresse qui fera office d'identifiant \
                               sur le site."
                          ]
                      ]
                  ; div
                      ~a:[ a_class [ "field" ] ]
                      [ label
                          ~a:
                            [ a_class [ "label" ]
                            ; a_label_for "register_user_name"
                            ]
                          [ txt "Nom d'utilisateur" ]
                      ; div
                          ~a:[ a_class [ "control" ] ]
                          [ input
                              ~a:
                                [ a_input_type @@ snd user_name
                                ; a_placeholder "J. Doe"
                                ; a_id "register_user_name"
                                ; a_name @@ fst user_name
                                ; a_class [ "input" ]
                                ]
                              ()
                          ]
                      ; p
                          ~a:[ a_class [ "help" ] ]
                          [ txt
                              "C'est un nom d'affichage, donc il faut que ça \
                               ait l'air un peu sérieux."
                          ]
                      ]
                  ; div
                      ~a:[ a_class [ "field" ] ]
                      [ label
                          ~a:
                            [ a_class [ "label" ]
                            ; a_label_for "register_user_password"
                            ]
                          [ txt "Mot de passe" ]
                      ; div
                          ~a:[ a_class [ "control" ] ]
                          [ input
                              ~a:
                                [ a_input_type @@ snd user_password
                                ; a_placeholder "azerty123"
                                ; a_id "register_user_password"
                                ; a_name @@ fst user_password
                                ; a_class [ "input" ]
                                ]
                              ()
                          ]
                      ; p
                          ~a:[ a_class [ "help" ] ]
                          [ txt
                              "Au minimum 7 caractères... parce que ce site \
                               est sécure."
                          ]
                      ]
                  ; div
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
                                [ a_input_type @@ snd confirm_user_password
                                ; a_placeholder "azerty123"
                                ; a_id "register_confirm_user_password"
                                ; a_name @@ fst confirm_user_password
                                ; a_class [ "input" ]
                                ]
                              ()
                          ]
                      ; p
                          ~a:[ a_class [ "help" ] ]
                          [ txt
                              "Ici il faut réécrire le même mot de passe, \
                               c'est juste pour être sur."
                          ]
                      ]
                  ; div
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
                  ]
              ]
          ]
      ]
;;
