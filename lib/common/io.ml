type filename = string
type dirname = string
type dirpath = string
type filepath = string

let read_dir path =
  try Ok (Sys.readdir path |> Array.to_list) with
  | _ -> Error.(to_try @@ Unable_to_read_dir path)
;;

let read_file path =
  try
    let channel = open_in path in
    let length = in_channel_length channel in
    let buffer = Bytes.create length in
    let () = really_input channel buffer 0 length in
    let () = close_in channel in
    Ok (Bytes.to_string buffer)
  with
  | _ -> Error.(to_try @@ Unable_to_read_file path)
;;
