open Tyxml

let href_font_inter =
  "https://fonts.googleapis.com/css2?"
  ^ "family=Inter:wght@100;200;400;500;700;900&display=swap"
;;

let page
    ~lang
    ~page_title
    ?(charset = "utf-8")
    ?(additional_meta = [])
    ?(additional_css = [])
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
  html ~a:[ a_lang lang ] p_head (body content)
;;
