type t =
  { index : int
  ; label : string
  ; file : string
  ; up : string list
  ; down : string list
  ; previous_migration : t option
  }

let make index label file up down previous_migration =
  { index; label; file; up; down; previous_migration }
;;

let rec hash { index; label; file; up; down; previous_migration } =
  let open Lib_crypto.Sha256 in
  hash_string @@ string_of_int index
  <|> hash_string label
  <|> hash_string file
  <|> hash_list hash_string up
  <|> hash_list hash_string down
  <|> hash_option hash previous_migration
;;

let is_valid_filename filename =
  let wrap i n = Some (i, n, filename) in
  try Scanf.sscanf filename "%u-%s@.yml%!" wrap with
  | _ -> None
;;
