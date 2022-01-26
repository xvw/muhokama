open Lib_common

type _ effects =
  | Fetch_migrations : { migrations_path : string } -> string list Try.t effects
  | Read_migration : { filepath : string } -> Assoc.Jsonm.t Try.t effects
  | Info : string -> unit effects
  | Warning : string -> unit effects
  | Error : Error.t -> 'a effects

module Freer = struct
  include Preface.Make.Freer_monad.Over (struct
    type 'a t = 'a effects
  end)

  let fetch_migrations ~migrations_path =
    perform @@ Fetch_migrations { migrations_path }
  ;;

  let read_migration ~migrations_path ~filepath =
    perform
    @@ Read_migration { filepath = Filename.concat migrations_path filepath }
  ;;

  let warning message = perform @@ Warning message
  let info message = perform @@ Info message
  let error err = perform @@ Error err
end

module Traverse = Preface.List.Monad.Traversable (Freer)
include Freer

let get_migrations_files ~migrations_path =
  fetch_migrations ~migrations_path
  >>= function
  | Ok list ->
    let sorted_list = List.sort_uniq String.compare list in
    return sorted_list
  | Error err -> error err
;;

let read_migration_yaml path =
  let open Try in
  let* content = Io.read_file path in
  Yaml.of_string content |> Result.map_error (function `Msg e -> Error.Yaml e)
;;

let handle program =
  let handler : type a. (a -> 'b) -> a f -> 'b =
   fun resume -> function
    | Fetch_migrations { migrations_path } ->
      let files = Io.list_files migrations_path in
      resume files
    | Read_migration { filepath } ->
      let migration_obj = read_migration_yaml filepath in
      resume migration_obj
    | Info message ->
      let () = Logs.debug (fun pp -> pp "%s" message) in
      resume ()
    | Warning message ->
      let () = Logs.warn (fun pp -> pp "%s" message) in
      resume ()
    | Error err ->
      let x = Error.Migration_context_error err in
      Try.error x
  in
  run { handler } program |> Lwt.return
;;
