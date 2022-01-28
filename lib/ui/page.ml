open Tyxml

let dummy =
  Template.page ~lang:"en" ~page_title:"A dummy page" Html.[ txt "Hello world" ]
;;

let register =
  let user_name, user_email, user_password, confirm_user_password =
    Lib_model.User.Pre_saved.formlet
  in
  Template.page
    ~lang:"fr"
    ~page_title:"Créer un compte"
    Html.
      [ h1 [ txt "Se créer un compte" ]
      ; form
          ~a:
            [ a_class [ "registration-form" ]
            ; a_method `Post
            ; a_action "/register/new"
            ]
          [ div
              [ label
                  ~a:[ a_label_for "register_user_name" ]
                  [ txt "Adresse électronique" ]
              ; input
                  ~a:
                    [ a_input_type @@ snd user_email
                    ; a_placeholder "you@domain.com"
                    ; a_id "register_user_email"
                    ; a_name @@ fst user_email
                    ]
                  ()
              ]
          ; div
              [ label
                  ~a:[ a_label_for "register_user_name" ]
                  [ txt "Nom d'utilisateur" ]
              ; input
                  ~a:
                    [ a_input_type @@ snd user_name
                    ; a_placeholder "J. Doe"
                    ; a_id "register_user_name"
                    ; a_name @@ fst user_name
                    ]
                  ()
              ]
          ; div
              [ label
                  ~a:[ a_label_for "register_user_password" ]
                  [ txt "Mot de passe" ]
              ; input
                  ~a:
                    [ a_input_type @@ snd user_password
                    ; a_placeholder "azerty123"
                    ; a_id "register_user_password"
                    ; a_name @@ fst user_password
                    ]
                  ()
              ]
          ; div
              [ label
                  ~a:[ a_label_for "register_confirm_user_password" ]
                  [ txt "Confirmation du mot de passe" ]
              ; input
                  ~a:
                    [ a_input_type @@ snd confirm_user_password
                    ; a_placeholder "azerty123"
                    ; a_id "register_confirm_user_password"
                    ; a_name @@ fst confirm_user_password
                    ]
                  ()
              ]
          ; input ~a:[ a_input_type `Submit; a_value "Valider !" ] ()
          ]
      ]
;;
