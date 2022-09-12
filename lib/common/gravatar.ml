type default_style =
  | Mp
  | Identicon
  | MonsterId
  | Wavatar
  | Retro
  | Robohash
  | Blank
  | Error404

let default_style_to_string = function
  | Mp -> "mp"
  | Identicon -> "identicon"
  | MonsterId -> "monsterid"
  | Wavatar -> "wavatar"
  | Retro -> "retro"
  | Robohash -> "robohash"
  | Blank -> "blank"
  | Error404 -> "404"
;;

let size_to_query_string =
  Option.fold ~none:[] ~some:(fun size -> [ Fmt.str "s=%d" size ])
;;

let default_style_to_query_string =
  Option.fold ~none:[] ~some:(fun style ->
    [ Fmt.str "d=%s" @@ default_style_to_string style ])
;;

let url ?default ?size email =
  let a =
    size_to_query_string size @ default_style_to_query_string default
    |> String.concat "&"
  in
  let e = String.(lowercase_ascii @@ trim email) in
  let h = Digest.(to_hex @@ string e) in
  "https://www.gravatar.com/avatar/" ^ h ^ "?" ^ a
;;
