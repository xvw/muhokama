let to_raw_html txml_document = txml_document |> Fmt.str "%a" (Tyxml.Html.pp ())
