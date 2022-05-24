open Lib_service
open Category_views

module List_moderable = struct
  let upgrade_btn =
    let open Tyxml.Html in
    input
      ~a:
        [ a_input_type `Submit
        ; a_class [ "button"; "is-success"; "is-small" ]
        ; a_name "action"
        ; a_value "upgrade"
        ]
      ()
  ;;

  let downgrade_btn =
    let open Tyxml.Html in
    input
      ~a:
        [ a_input_type `Submit
        ; a_class [ "button"; "is-danger"; "is-small" ]
        ; a_name "action"
        ; a_value "downgrade"
        ]
      ()
  ;;

  let action_for = function
    | Models.User.State.Admin -> []
    | Models.User.State.Inactive -> [ upgrade_btn ]
    | _ -> [ upgrade_btn; downgrade_btn ]
  ;;

  let change_state_form csrf_token user =
    let open Tyxml.Html in
    let Models.User.{ state; id; _ } = user in
    Templates.Util.form ~:Endpoints.Admin.user_state_change ~csrf_token
    @@ (input ~a:[ a_input_type `Hidden; a_name "user_id"; a_value id ] ()
       :: action_for state)
  ;;

  let user_line csrf user =
    let open Tyxml.Html in
    let Models.User.{ email; name; state; _ } = user in
    tr
      [ td [ txt name ]
      ; td [ txt email ]
      ; td
          ~a:[ a_class [ "has-text-centered" ] ]
          [ Templates.Component.user_state_tag state ]
      ; td
          ~a:[ a_class [ "has-text-centered" ] ]
          [ change_state_form csrf user ]
      ]
  ;;

  let all csrf users =
    let open Tyxml.Html in
    let hd =
      thead
        [ tr
            [ th [ txt "Nom d'utilisateur" ]
            ; th [ txt "Courrier électronique" ]
            ; th ~a:[ a_class [ "has-text-centered" ] ] [ txt "Statut" ]
            ; th ~a:[ a_class [ "has-text-centered" ] ] [ txt "Action" ]
            ]
        ]
    in
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
    @@ List.map (user_line csrf) users
  ;;
end

let admin_menu () =
  let open Tyxml.Html in
  aside
    ~a:[ a_class [ "column"; "menu"; "is-2" ] ]
    [ p ~a:[ a_class [ "menu-label" ] ] [ txt "Général" ]
    ; ul
        ~a:[ a_class [ "menu-list" ] ]
        [ li [ Templates.Util.a ~:Endpoints.Admin.user [ txt "Utilisateurs" ] ]
        ; li
            [ Templates.Util.a ~:Endpoints.Admin.category [ txt "Catégories" ] ]
        ]
    ]
;;

let admin_layout ?flash_info ~page_title ?user content =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title
    ?flash_info
    ?user
    Tyxml.Html.
      [ div
          ~a:[ a_class [ "columns" ] ]
          [ admin_menu ()
          ; div ~a:[ a_class [ "container"; "column" ] ] content
          ]
      ]
;;

let users ?flash_info ~csrf_token ?user ~active ~inactive () =
  admin_layout
    ?flash_info
    ?user
    ~page_title:"Utilisateurs"
    Tyxml.Html.
      [ div
          [ h1 ~a:[ a_class [ "title" ] ] [ txt "Utilisateurs modérables" ]
          ; div
              [ div
                  ~a:[ a_class [ "mb-6" ] ]
                  [ h2
                      ~a:[ a_class [ "title"; "is-4" ] ]
                      [ txt "Utilisateurs inactifs" ]
                  ; List_moderable.all csrf_token inactive
                  ]
              ; div
                  [ h2
                      ~a:[ a_class [ "title"; "is-4" ] ]
                      [ txt "Utilisateurs actifs" ]
                  ; List_moderable.all csrf_token active
                  ]
              ]
          ]
      ]
;;

let categories ?flash_info ~csrf_token ?user categories =
  admin_layout
    ?flash_info
    ?user
    ~page_title:"Catégories"
    Tyxml.Html.
      [ div
          [ h1 ~a:[ a_class [ "title" ] ] [ txt "Gestion des catégories" ]
          ; div
              ~a:[ a_class [ "mb-6" ] ]
              [ div
                  [ h2
                      ~a:[ a_class [ "title"; "is-4" ] ]
                      [ txt "Catégories existantes" ]
                  ; Category.all categories
                  ]
              ]
          ; div
              [ h2
                  ~a:[ a_class [ "title"; "is-4" ] ]
                  [ txt "Créer une nouvelle catégorie" ]
              ; Category.creation_form csrf_token
              ]
          ]
      ]
;;
