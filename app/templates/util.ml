open Tyxml

let preconnect ?(crossorigin = false) href =
  let crossorigin =
    if crossorigin then Html.[ a_crossorigin `Anonymous ] else []
  in
  Html.(link ~rel:[ `Other "preconnect" ] ~a:crossorigin ~href ())
;;

let stylesheet href = Html.(link ~rel:[ `Stylesheet ] ~href ())

let csrf_input value =
  Html.(
    input ~a:[ a_input_type `Hidden; a_name "dream.csrf"; a_value value ] ())
;;

let format_date date =
  let (year, month, day), ((hour, min, _), _) =
    Ptime.to_date_time ~tz_offset_s:(3600 * 2) date
  in
  Fmt.str "%04d-%02d-%02d à %02d:%02d" year month day hour min
;;

let a ?(a = []) endpoint ctn =
  Lib_service.Endpoint.handle_href endpoint (fun uri ->
    let a' = a in
    let open Tyxml.Html in
    let attrib = a_href uri :: a' in
    a ~a:attrib ctn)
;;

let form ?(a = []) ?csrf_token endpoint ctn =
  Lib_service.Endpoint.handle_form endpoint (fun method_ action ->
    let a' = a in
    let open Tyxml.Html in
    let ctn =
      Option.fold
        ~none:ctn
        ~some:(fun token -> csrf_input token :: ctn)
        csrf_token
    in
    let attrib = a_method method_ :: a_action action :: a' in
    form ~a:attrib ctn)
;;
