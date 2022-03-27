let normalize_name value = value |> String.trim |> String.lowercase_ascii

let hash_password ~email ~password =
  Lib_crypto.Sha256.(
    hash_string @@ normalize_name email <|> hash_string password)
;;
