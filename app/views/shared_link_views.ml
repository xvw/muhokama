open Lib_service

let creation_form ~csrf_token =
  Templates.Util.form
    ~:Endpoints.Shared_link.create
    ~csrf_token
    Tyxml.Html.
      [ input
          ~a:
            [ a_input_type `Text
            ; a_placeholder "Titre du lien"
            ; a_name "link_title"
            ; a_class [ "input" ]
            ]
          ()
      ; input
          ~a:
            [ a_input_type `Url
            ; a_placeholder "https://votre-lien.fun"
            ; a_name "link_url"
            ; a_class [ "input" ]
            ]
          ()
      ; input
          ~a:
            [ a_input_type `Submit
            ; a_value "Valider !"
            ; a_class [ "button"; "is-link" ]
            ]
          ()
      ]
;;

let root ?flash_info ~csrf_token ~user () =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title:"Liens partagés"
    ?flash_info
    ~user
    Tyxml.Html.
      [ div
          [ h1 ~a:[ a_class [ "title" ] ] [ txt "Liens partagés" ]
          ; creation_form ~csrf_token
          ]
      ]
;;
