open Lib_common

let from_tyxml doc = doc |> Fmt.str "%a" (Tyxml.Html.pp ())

let handle_form ?(csrf = true) request formlet =
  let open Lwt_util in
  let*? params = Dream.form ~csrf request >|= Try.ok in
  let*? fields = return @@ Try.form params in
  return @@ formlet fields
;;
