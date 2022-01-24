let hash_bytes bytes = Hacl_star.Hacl.SHA2_256.hash bytes
let hash_string string = hash_bytes @@ Bytes.of_string string

let to_string sha =
  sha
  |> Bytes.to_string
  |> Format.asprintf "%a" Fmt.(on_string @@ octets ~sep:nop ())
;;

let to_bytes x = x
let equal = Bytes.equal
let pp ppf x = Format.fprintf ppf "%s" (to_string x)

include Preface.Make.Monoid.Via_combine_and_neutral (struct
  type t = Bytes.t

  let neutral = Bytes.empty |> hash_bytes
  let combine a b = Bytes.cat a b |> hash_bytes
end)

let hash_list f list =
  List.fold_left (fun acc elt -> acc <|> f elt) neutral list
;;

let hash_option f = function
  | None -> hash_string "None()"
  | Some x -> hash_string "Option(" <|> f x <|> hash_string ")"
;;
