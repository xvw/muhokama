open Tyxml

let href_font_inter =
  "https://fonts.googleapis.com/css2?"
  ^ "family=Inter:wght@100;200;400;500;700;900&display=swap"
;;

let render_leaf_message l = function
  | Some message ->
    let l = Html.txt (l ^ ": ") in
    Html.[ strong [ l ]; txt message ]
  | None -> Html.[ strong [ txt l ] ]
;;

let rec tree_to_ul =
  let open Lib_common.Error in
  function
  | Leaf { label = l; message } ->
    Html.
      [ span ~a:[ a_class [ "error-leaf" ] ] (render_leaf_message l message) ]
  | Node { label = l; tree } -> render_tree l tree

and render_tree l = function
  | [] -> Html.[ strong [ txt l ] ]
  | xs ->
    Html.
      [ strong [ txt (l ^ ": ") ]
      ; ul
          ~a:[ a_class [ "error-tree" ] ]
          (List.map (fun e -> li (tree_to_ul e)) xs)
      ]
;;

let render_notif =
  let open Html in
  function
  | Notif.Action message -> div ~a:[ a_id "tooltip-action" ] [ txt message ]
  | Notif.Info message -> div ~a:[ a_id "tooltip-info" ] [ txt message ]
  | Notif.Alert message -> div ~a:[ a_id "tooltip-alert" ] [ txt message ]
  | Notif.Error_tree tree -> div ~a:[ a_id "tooltip-alert" ] (tree_to_ul tree)
  | Notif.Nothing -> div ~a:[ a_class [ "void" ] ] []
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
    :: List.map (fun m -> meta ~a:m ()) additional_meta
  in
  let p_stylesheet =
    (* Yes, using Google font is a little bit sad... *)
    Util.preconnect "https://fonts.googleapis.com"
    :: Util.preconnect ~crossorigin:true "https://fonts.gstatic.com"
    :: Util.stylesheet href_font_inter
    :: Util.stylesheet "/css/normalize.css"
    :: Util.stylesheet "/css/style.css"
    :: List.map Util.stylesheet additional_css
  in
  let p_head = head p_title @@ p_meta @ p_stylesheet in
  let notif = render_notif notifs in
  html
    ~a:[ a_lang lang ]
    p_head
    (body
       [ header
           [ h1 [ txt "muhokama" ]
           ; h2 [ txt "Ça veut dire 'Discussion' en Ouzbek" ]
           ; nav
               [ a ~a:[ a_href "/" ] [ txt "Accueil" ]
               ; a ~a:[ a_href "/register" ] [ txt "Créer un compte" ]
               ]
           ]
       ; notif
       ; main content
       ; footer
           [ p
               [ strong [ txt "Muhokama " ]
               ; txt "est un logiciel libre écrit en "
               ; a ~a:[ a_href "https://ocaml.org" ] [ txt "OCaml" ]
               ; txt "."
               ; br ()
               ; txt "Son code est source est distribué sous licence "
               ; strong [ txt "MIT" ]
               ; txt "."
               ]
           ; div
               ~a:[ a_class [ "multi-enumeration" ] ]
               [ ul
                   [ li
                       [ a
                           ~a:[ a_href "https://github.com/xvw/muhokama" ]
                           [ txt "Code source" ]
                       ]
                   ; li
                       [ a
                           ~a:
                             [ a_href "https://github.com/xvw/muhokama/issues" ]
                           [ txt "Bug tracker" ]
                       ]
                   ]
               ]
           ]
       ])
;;
