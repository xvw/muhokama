open Tyxml

let preconnect ?(crossorigin = false) href =
  let crossorigin =
    if crossorigin then Html.[ a_crossorigin `Anonymous ] else []
  in
  Html.(link ~rel:[ `Other "preconnect" ] ~a:crossorigin ~href ())
;;

let stylesheet href = Html.(link ~rel:[ `Stylesheet ] ~href ())
