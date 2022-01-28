open Lib_common
open Lib_crypto
module S = Map.Make (Int)

type t = Migration.t S.t

type step =
  | Up of (int * Migration.t) list
  | Down of (int * Migration.t) list * (int * Sha256.t)
  | Nothing

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
    else error @@ Error.migration_invalid_successor ~expected_index ~given_index
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
  S.max_binding_opt s
  |> Option.fold
       ~none:(0, Sha256.(to_string neutral))
       ~some:(fun (i, m) -> Migration.(i, Sha256.to_string @@ hash m))
;;

let to_list = S.bindings

let compute_up_path s current target =
  let steps = S.filter (fun index _ -> index > current && index <= target) s in
  Up (S.bindings steps)
;;

let compute_down_path s current target =
  let steps = S.filter (fun index _ -> index > target && index <= current) s in
  let state =
    S.find_opt target s
    |> Option.fold ~none:(0, Sha256.neutral) ~some:(fun m ->
           Migration.(m.index, hash m))
  in
  Down (S.bindings steps |> List.rev, state)
;;

let get_migrations ~current ?target s =
  let max_index, _ = current_state s in
  let target = Option.value ~default:max_index target in
  if current > max_index
  then Error.(to_try @@ migration_invalid_state ~current_state:current)
  else if target > max_index
  then Error.(to_try @@ migration_invalid_target ~given_target:target)
  else if Int.equal current target
  then Ok Nothing
  else
    Try.ok
      (if target > current
      then compute_up_path s current target
      else compute_down_path s current target)
;;

let check_hash s index hash =
  if index = 0 && String.equal hash Sha256.(to_string neutral)
  then Try.ok ()
  else (
    let invalid =
      Error.(to_try @@ migration_invalid_checksum ~given_index:index)
    in
    let r = S.find_opt index s in
    Option.fold
      ~none:invalid
      ~some:(fun x ->
        let h = Migration.hash x |> Sha256.to_string in
        if String.equal h hash then Try.ok () else invalid)
      r)
;;
