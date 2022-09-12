let compute_meta charset additional_meta =
  let open Tyxml.Html in
  meta ~a:[ a_charset charset ] ()
  :: meta
       ~a:[ a_name "viewport"; a_content "width=device-width, initial-scale=1" ]
       ()
  :: List.map (fun m -> meta ~a:m ()) additional_meta
;;

let compute_title prefix suffix =
  let prefix = Option.value ~default:"" prefix in
  Tyxml.Html.(title (txt (prefix ^ suffix)))
;;

let compute_stylesheet additional_css =
  Util.stylesheet "https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css"
  :: Util.stylesheet "/css/style.css"
  :: List.map Util.stylesheet additional_css
;;

let compute_head prefix suffix charset additional_meta additional_css =
  let open Tyxml.Html in
  head
    (compute_title prefix suffix)
    (compute_meta charset additional_meta @ compute_stylesheet additional_css)
;;

let default
  ~lang
  ~page_title
  ?(prefix_title = Some "Muhokama - ")
  ?(charset = "utf-8")
  ?(additional_meta = [])
  ?(additional_css = [])
  ?flash_info
  ?user
  content
  =
  let open Tyxml.Html in
  html
    ~a:[ a_lang lang ]
    (compute_head
       prefix_title
       page_title
       charset
       additional_meta
       additional_css)
    (body
       [ Component.navbar user
       ; Component.main_header
       ; main
           [ section
               ~a:[ a_class [ "section"; "main-content"; "container" ] ]
               [ Component.flash_info flash_info; div content ]
           ]
       ; Component.main_footer
       ])
;;
