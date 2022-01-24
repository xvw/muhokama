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
