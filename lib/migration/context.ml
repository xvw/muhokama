open Lib_common
open Lib_crypto
module S = Map.Make (Int)

type t = Migration.t S.t

let equal = S.equal Migration.equal

let init ~migrations_path =
  let open Effect in
  let* migrations = get_migrations_files ~migrations_path in
  List.fold_left
    (fun eff file ->
      let* ctx, previous = eff in
      let previous_index, previous_hash =
        Option.value ~default:(0, Sha256.neutral) previous
      in
      let data = Migration.is_valid_filename file in
      match data with
      | Some (given_index, label, filepath) ->
        let expected_index = succ previous_index in
        if Int.equal expected_index given_index
        then
          let* jsonm_obj = read_migration ~migrations_path ~filepath in
          Try.(
            jsonm_obj
            >>= Migration.build expected_index label filepath previous_hash)
          |> function
          | Error err -> error err
          | Ok migration ->
            let migration_hash = Migration.hash migration in
            return
              ( S.add given_index migration ctx
              , Some (expected_index, migration_hash) )
        else
          error
          @@ Error.Invalid_migration_successor { expected_index; given_index }
      | None ->
        let* _ = warning @@ Fmt.str "Invalid name scheme: %s" file in
        return (ctx, previous))
    (Effect.return (S.empty, None))
    migrations
  >|= Stdlib.fst
  >|= Try.ok
;;

let to_list = S.bindings
