let main_header =
  let open Tyxml.Html in
  header
    ~a:[ a_class [ "hero"; "is-primary"; "is-small"; "is-info" ] ]
    [ div
        ~a:[ a_class [ "hero-body" ] ]
        [ h1 ~a:[ a_class [ "title" ] ] [ txt "Muhokama" ]
        ; h2
            ~a:[ a_class [ "subtitle" ] ]
            [ txt "Ça veut dire "; i [ txt "discussion" ]; txt " en Ouzbek" ]
        ]
    ]
;;

let main_footer =
  let open Tyxml.Html in
  footer
    ~a:[ a_class [ "footer" ] ]
    [ div
        ~a:[ a_class [ "content"; "has-text-centered" ] ]
        [ p
            [ strong [ txt "Muhokama" ]
            ; txt " est un logiciel libre écrit en "
            ; a ~a:[ a_href "https;//ocaml.org" ] [ txt "OCaml" ]
            ; txt " pour discuter."
            ; br ()
            ; txt "Son "
            ; a
                ~a:[ a_href "https://github.com/xvw/muhokama" ]
                [ txt "code source" ]
            ; txt " est distribué sous licence "
            ; strong [ txt "MIT" ]
            ; txt "."
            ]
        ]
    ]
;;

let unconnected_navbar =
  let open Tyxml.Html in
  nav
    ~a:[ a_class [ "navbar"; "is-link" ]; a_role [ "navigation" ] ]
    [ div
        ~a:[ a_class [ "navbar-menu"; "is-active" ] ]
        [ div
            ~a:[ a_class [ "navbar-start" ] ]
            [ a ~a:[ a_href "/"; a_class [ "navbar-item" ] ] [ txt "Home" ]
            ; a
                ~a:[ a_href "/register/"; a_class [ "navbar-item" ] ]
                [ txt "Créer un compte" ]
            ]
        ]
    ]
;;

let error_tree_leaf error_label =
  let open Tyxml.Html in
  function
  | Some error_message ->
    let error_label = txt (error_label ^ ": ") in
    [ strong [ error_label ]; txt error_message ]
  | None -> [ strong [ txt error_label ] ]
;;

let rec error_tree =
  let open Lib_common.Error in
  let open Tyxml.Html in
  function
  | Leaf { label = error_label; message = error_message } ->
    [ span (error_tree_leaf error_label error_message) ]
  | Node { label = error_label; tree } -> render_tree error_label tree

and render_tree error_label =
  let open Tyxml.Html in
  function
  | [] -> [ strong [ txt error_label ] ]
  | xs ->
    [ strong [ txt (error_label ^ ": ") ]
    ; ul (List.map (fun e -> li (error_tree e)) xs)
    ]
;;

let flash_info_box class_ flash_content =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "message"; class_; "is-small" ] ]
    [ div
        ~a:[ a_class [ "message-body" ] ]
        [ div ~a:[ a_class [ "content" ] ] flash_content ]
    ]
;;

let flash_info =
  let open Tyxml.Html in
  function
  | Some (Model.Flash_info.Action message) ->
    flash_info_box "is-success" [ txt message ]
  | Some (Model.Flash_info.Info message) ->
    flash_info_box "is-info" [ txt message ]
  | Some (Model.Flash_info.Alert message) ->
    flash_info_box "is-danger" [ txt message ]
  | Some (Model.Flash_info.Error_tree tree) ->
    flash_info_box "is-danger" (error_tree tree)
  | Some Model.Flash_info.Nothing | None -> div ~a:[ a_class [ "void" ] ] []
;;
