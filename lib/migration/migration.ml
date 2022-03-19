open Lib_common
open Lib_crypto

type t =
  { index : int
  ; label : string
  ; file : string
  ; up : string list
  ; down : string list
  ; previous_hash : Sha256.t
  }

type file =
  | Valid_name_scheme of
      { index : int
      ; label : string
      ; file : string
      }
  | Invalid_name_scheme of { file : string }

let make index label file up down previous_hash =
  { index; label; file; up; down; previous_hash }
;;

let hash { index; label; file; up; down = _; previous_hash } =
  let open Sha256 in
  hash_string @@ string_of_int index
  <|> hash_string label
  <|> hash_string file
  <|> hash_list hash_string up
  <|> previous_hash
;;

let is_valid_filename file =
  let wrap index label = Valid_name_scheme { index; label; file } in
  try Scanf.sscanf file "%u-%s@.yml%!" wrap with
  | _ -> Invalid_name_scheme { file }
;;

let list_of_string_or_string x =
  let open Validate in
  let open Assoc.Jsonm in
  list_of string x <|> ((fun x -> [ x ]) <$> string x)
;;

let build index label file previous_migration jsonm_obj =
  let create up down = make index label file up down previous_migration in
  let open Validate in
  let open Assoc.Jsonm in
  object_and
    (fun obj ->
      create
      <$> required list_of_string_or_string "up" obj
      <*> required list_of_string_or_string "down" obj)
    jsonm_obj
  |> run ~name:file
;;

let equal a b =
  let hash_a = hash a
  and hash_b = hash b in
  Sha256.equal hash_a hash_b
;;

let equal_file a b =
  match a, b with
  | ( Valid_name_scheme { label = label_a; index = index_a; file = file_a }
    , Valid_name_scheme { label = label_b; index = index_b; file = file_b } ) ->
    String.equal label_a label_b
    && String.equal file_a file_b
    && Int.equal index_a index_b
  | Invalid_name_scheme { file = file_a }, Invalid_name_scheme { file = file_b }
    -> String.equal file_a file_b
  | _ -> false
;;

let pp_file ppf = function
  | Invalid_name_scheme { file } ->
    Fmt.pf ppf "Invalid_name_scheme { file =  %a}" Fmt.(quote string) file
  | Valid_name_scheme { index; label; file } ->
    Fmt.pf
      ppf
      "Valid_name_scheme { index = %d; label = %a; file = %a }"
      index
      Fmt.(quote string)
      label
      Fmt.(quote string)
      file
;;

let pp ppf { index; label; file; up; down; previous_hash } =
  let quoted_string = Fmt.(quote string) in
  let list_of_string = Preface.List.pp quoted_string in
  Fmt.pf
    ppf
    "{index = %d; label = %a; file = %a; up = %a; down = %a; previous_hash = \
     %a}"
    index
    quoted_string
    label
    quoted_string
    file
    list_of_string
    up
    list_of_string
    down
    Sha256.pp
    previous_hash
;;
