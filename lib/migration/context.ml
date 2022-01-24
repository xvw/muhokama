open Lib_common
open Lib_crypto
module S = Map.Make (Int)

type t = Migration.t S.t

let equal = S.equal Migration.equal

let finalize_migration ctx file given_index expected_index =
  let open Effect in
  function
  | Result.Error err -> error err
  | Result.Ok migration ->
    let* () = info @@ Fmt.str "Storing file: %s in context" file in
    let migration_hash = Migration.hash migration in
    return
      (S.add given_index migration ctx, Some (expected_index, migration_hash))
;;

let collapse_effects migrations_path eff file =
  let open Effect in
  let* ctx, previous = eff in
  let previous_index, previous_hash =
    Option.value ~default:(0, Sha256.neutral) previous
  in
  let* () = info @@ Fmt.str "Process file: %s" file in
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
      |> finalize_migration ctx file given_index expected_index
    else
      error @@ Error.Invalid_migration_successor { expected_index; given_index }
  | None ->
    let* _ = warning @@ Fmt.str "Invalid name scheme: %s" file in
    return (ctx, previous)
;;

let init ~migrations_path =
  let open Effect in
  let* () = info @@ Fmt.str "Reading migration path: %s" migrations_path in
  let* migrations_files = get_migrations_files ~migrations_path in
  let+ ctx, _ =
    List.fold_left
      (collapse_effects migrations_path)
      (return (S.empty, None))
      migrations_files
  in
  Ok ctx
;;

let current_state s =
  S.max_binding_opt s |> Option.fold ~none:0 ~some:Stdlib.fst
;;

let to_list = S.bindings
