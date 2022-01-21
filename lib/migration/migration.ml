open Lib_common

type t =
  { index : int
  ; label : string
  ; file : string
  ; up : string list
  ; down : string list
  ; previous_migration : Lib_crypto.Sha256.t option
  }

let make index label file up down previous_migration =
  { index; label; file; up; down; previous_migration }
;;

let hash { index; label; file; up; down; previous_migration } =
  let open Lib_crypto.Sha256 in
  hash_string @@ string_of_int index
  <|> hash_string label
  <|> hash_string file
  <|> hash_list hash_string up
  <|> hash_list hash_string down
  <|> hash_option Fun.id previous_migration
;;

let is_valid_filename filename =
  let wrap i n = Some (i, n, filename) in
  try Scanf.sscanf filename "%u-%s@.yml%!" wrap with
  | _ -> None
;;

let build index label file previous_migration json_obj =
  let mk up down = make index label file up down previous_migration in
  let open Validate in
  let open Assoc.Jsonm in
  object_and
    (fun obj ->
      mk
      <$> required (list_of string) "up" obj
      <*> required (list_of string) "down" obj)
    json_obj
  |> run ~provider:file
;;
