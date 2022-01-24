let to_raw_html txml_document =
  let raw = txml_document |> Fmt.str "%a" (Tyxml.Html.pp ()) in
  `Html raw
;;
