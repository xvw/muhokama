let escape_special_chars subject =
  let length = String.length subject in
  let buffer = Buffer.create length in
  let rec aux i =
    if i < length
    then (
      let () =
        match String.get subject i with
        | '<' -> Buffer.add_string buffer "&lt;"
        | '>' -> Buffer.add_string buffer "&gt;"
        | '&' -> Buffer.add_string buffer "&amp;"
        | '\'' -> Buffer.add_string buffer "&apos;"
        | '\"' -> Buffer.add_string buffer "&quot;"
        | c -> Buffer.add_char buffer c
      in
      aux (i + 1))
  in
  let () = aux 0 in
  buffer |> Buffer.to_bytes |> Bytes.to_string
;;
