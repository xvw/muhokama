let sanitize_path path =
  let to_list str =
    match String.split_on_char '/' str with
    | "" :: "" :: fragments | "" :: fragments | fragments -> fragments
  in
  match String.index_opt path '?' with
  | Some 0 -> []
  | Some i ->
    let substring = String.sub path 0 i in
    to_list substring
  | None -> to_list path
;;
