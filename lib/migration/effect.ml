open Lib_common

type _ effects =
  | Fetch_migrations : string -> string list Try.t effects
  | Read_migration : string -> Assoc.Jsonm.t Try.t effects
  | Info : string -> unit effects
  | Warning : string -> unit effects
  | Error : Error.t -> 'a effects

module Freer = struct
  include Preface.Make.Freer_monad.Over (struct
    type 'a t = 'a effects
  end)

  let fetch_migrations migration_dir = perform @@ Fetch_migrations migration_dir

  let read_migration migration_dir file =
    perform @@ Read_migration (Filename.concat migration_dir file)
  ;;

  let warning message = perform @@ Warning message
  let info message = perform @@ Info message
  let error err = perform @@ Error err
end

module Traverse = Preface.List.Monad.Traversable (Freer)
include Freer

let get_migrations_files migration_dir =
  let* migrations = fetch_migrations migration_dir in
  match migrations with
  | Error err -> error err
  | Ok files ->
    files
    |> List.map Migration.is_valid_filename
    |> List.sort (fun left right ->
         match left, right with
         | ( Migration.Valid_name_scheme { index = a; _ }
           , Migration.Valid_name_scheme { index = b; _ } ) -> Int.compare a b
         | Migration.Valid_name_scheme _, _ ->
           Int.max_int (* put invalid file at the begining *)
         | _ -> Int.min_int)
    |> return
;;

let read_migration_file file =
  let open Try in
  let* file_content = Io.read_file file in
  Yaml.of_string file_content
  |> Result.map_error (function `Msg e -> Error.Yaml e)
;;

let read_migration_file_to_assoc migration_dir file =
  let* migration = read_migration migration_dir file in
  match migration with
  | Error err -> error err
  | Ok migration -> return migration
;;

let default_runner program =
  let handler : type b. (b -> 'a) -> b f -> 'a =
   fun continue -> function
    | Fetch_migrations migration_path ->
      migration_path |> Io.list_files |> continue
    | Read_migration file -> file |> read_migration_file |> continue
    | Info message ->
      Logs.info (fun pp -> pp "%s" message);
      continue ()
    | Warning message ->
      Logs.warn (fun pp -> pp "%s" message);
      continue ()
    | Error err -> Try.error err
  in
  run { handler } program
;;
