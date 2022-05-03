type t =
  | Action of string
  | Info of string
  | Alert of string
  | Error_tree of Lib_common.Error.error_tree
  | Nothing
[@@deriving yojson]

let serialize notification =
  notification |> yojson_of_t |> Yojson.Safe.to_string
;;

let unserialize json =
  try json |> Yojson.Safe.from_string |> t_of_yojson with
  | _ -> Nothing
;;
