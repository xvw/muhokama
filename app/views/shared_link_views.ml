open Lib_common
open Lib_service

let creation_form ~csrf_token =
  Templates.Util.form
    ~:Endpoints.Shared_link.create
    ~csrf_token
    Tyxml.Html.
      [ div
          ~a:[ a_class [ "field" ] ]
          [ p
              ~a:[ a_class [ "control"; "is-full" ] ]
              [ input
                  ~a:
                    [ a_input_type `Text
                    ; a_placeholder "Titre du lien"
                    ; a_name "link_title"
                    ; a_class [ "input"; "is-small" ]
                    ]
                  ()
              ]
          ]
      ; div
          ~a:[ a_class [ "field" ] ]
          [ p
              ~a:[ a_class [ "control"; "is-full" ] ]
              [ input
                  ~a:
                    [ a_input_type `Url
                    ; a_placeholder "https://votre-lien.fun"
                    ; a_name "link_url"
                    ; a_class [ "input"; "is-small" ]
                    ]
                  ()
              ]
          ]
      ; input
          ~a:
            [ a_input_type `Submit
            ; a_value "Soumettre !"
            ; a_class [ "button"; "is-link"; "is-small" ]
            ]
          ()
      ]
;;

module List = struct
  let line shared_link =
    let open Tyxml.Html in
    let open Models.Shared_link.Listable in
    let src =
      Gravatar.(url ~default:Identicon ~size:48 shared_link.user_email)
    in
    let alt = "Avatar of " ^ shared_link.user_name in
    tr
      [ td
          ~a:[ a_class [ "is-vcentered" ] ]
          [ img ~a:[ a_class [ "image"; "is-48x48" ] ] ~src ~alt () ]
      ; td
          ~a:[ a_class [ "is-vcentered"; "is-fullwidth" ] ]
          [ a ~a:[ a_href shared_link.url ] [ txt shared_link.title ] ]
      ; td
          ~a:[ a_class [ "is-vcentered" ] ]
          [ span
              [ txt
                @@ "le "
                ^ Templates.Util.format_date shared_link.creation_date
              ]
          ]
      ]
  ;;

  let all links =
    let open Tyxml.Html in
    table ~a:[ a_class [ "table"; "is-fullwidth"; "is-striped"; "content" ] ]
    @@ List.map line links
  ;;
end

let root ?flash_info ~csrf_token ~user ~links () =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title:"Liens partagés"
    ?flash_info
    ~user
    Tyxml.Html.
      [ div
          ~a:[ a_class [ "box" ] ]
          [ h1 ~a:[ a_class [ "title" ] ] [ txt "Proposer un nouveau lien" ]
          ; creation_form ~csrf_token
          ]
      ; div
          [ h1 ~a:[ a_class [ "title" ] ] [ txt "Liens partagés" ]
          ; List.all links
          ]
      ]
;;
