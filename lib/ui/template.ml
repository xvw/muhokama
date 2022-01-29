open Tyxml

let render_leaf_message l = function
  | Some message ->
    let l = Html.txt (l ^ ": ") in
    Html.[ strong [ l ]; txt message ]
  | None -> Html.[ strong [ txt l ] ]
;;

let rec tree_to_ul =
  let open Lib_common.Error in
  function
  | Leaf { label = l; message } -> Html.[ span (render_leaf_message l message) ]
  | Node { label = l; tree } -> render_tree l tree

and render_tree l = function
  | [] -> Html.[ strong [ txt l ] ]
  | xs ->
    Html.
      [ strong [ txt (l ^ ": ") ]
      ; ul (List.map (fun e -> li (tree_to_ul e)) xs)
      ]
;;

let notif_box k message =
  let open Html in
  div
    ~a:[ a_class [ "message"; k; "is-small" ] ]
    [ div
        ~a:[ a_class [ "message-body" ] ]
        [ div ~a:[ a_class [ "content" ] ] message ]
    ]
;;

let render_notif =
  let open Html in
  function
  | Notif.Action message -> notif_box "is-success" [ txt message ]
  | Notif.Info message -> notif_box "is-info" [ txt message ]
  | Notif.Alert message -> notif_box "is-danger" [ txt message ]
  | Notif.Error_tree tree -> notif_box "is-danger" (tree_to_ul tree)
  | Notif.Nothing -> div ~a:[ a_class [ "void" ] ] []
;;

let main_header =
  let open Html in
  header
    ~a:[ a_class [ "hero"; "is-primary"; "is-small"; "is-info" ] ]
    [ div
        ~a:[ a_class [ "hero-body" ] ]
        [ h1 ~a:[ a_class [ "title" ] ] [ txt "Muhokama" ]
        ; h2
            ~a:[ a_class [ "subtitle" ] ]
            [ txt "Ça veut dire 'discussion' en Ouzbek" ]
        ]
    ]
;;

let main_footer =
  let open Html in
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
  let open Html in
  nav
    ~a:[ a_class [ "navbar"; "is-link" ]; a_role [ "navigation" ] ]
    [ div
        ~a:[ a_class [ "navbar-menu"; "is-active" ] ]
        [ div
            ~a:[ a_class [ "navbar-start" ] ]
            [ a ~a:[ a_href "/"; a_class [ "navbar-item" ] ] [ txt "Home" ]
            ; a
                ~a:[ a_href "/register"; a_class [ "navbar-item" ] ]
                [ txt "Créer un compte" ]
            ]
        ]
    ]
;;

let page
    ~lang
    ~page_title
    ?(charset = "utf-8")
    ?(additional_meta = [])
    ?(additional_css = [])
    ?(notifs = Notif.Nothing)
    content
  =
  let open Html in
  let p_title = title (txt page_title) in
  let p_meta =
    meta ~a:[ a_charset charset ] ()
    :: meta
         ~a:
           [ a_name "viewport"
           ; a_content "width=device-width, initial-scale=1"
           ]
         ()
    :: List.map (fun m -> meta ~a:m ()) additional_meta
  in
  let p_stylesheet =
    Util.stylesheet "https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css"
    :: Util.stylesheet "/css/style.css"
    :: List.map Util.stylesheet additional_css
  in
  let p_head = head p_title @@ p_meta @ p_stylesheet in
  let notif = render_notif notifs in
  html
    ~a:[ a_lang lang ]
    p_head
    (body
       [ unconnected_navbar
       ; main_header
       ; main
           [ section
               ~a:[ a_class [ "section"; "main-content" ] ]
               [ notif; div content ]
           ]
       ; main_footer
       ])
;;
