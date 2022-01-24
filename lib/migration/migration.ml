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

let is_valid_filename filename =
  let wrap i n = Some (i, n, filename) in
  try Scanf.sscanf filename "%u-%s@.yml%!" wrap with
  | _ -> None
;;

let list_of_string_or_string x =
  let open Validate in
  let open Assoc.Jsonm in
  list_of string x <|> ((fun x -> [ x ]) <$> string x)
;;

let build index label file previous_migration json_obj =
  let mk up down = make index label file up down previous_migration in
  let open Validate in
  let open Assoc.Jsonm in
  object_and
    (fun obj ->
      mk
      <$> required list_of_string_or_string "up" obj
      <*> required list_of_string_or_string "down" obj)
    json_obj
  |> run ~provider:file
;;

let equal a b =
  Int.equal a.index b.index
  && String.equal a.label b.label
  && String.equal a.file b.file
  && List.equal String.equal a.up b.up
  && List.equal String.equal a.down b.down
  && Sha256.equal a.previous_hash b.previous_hash
;;

let pp ppf { index; label; file; up; down; previous_hash } =
  let s = Fmt.(quote string) in
  let l = Preface.List.pp s in
  Format.fprintf
    ppf
    "{index = %d; label = %a; file = %a; up = %a; down = %a; previous_hash = \
     %a}"
    index
    s
    label
    s
    file
    l
    up
    l
    down
    Sha256.pp
    previous_hash
;;
