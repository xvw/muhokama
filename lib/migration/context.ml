open Lib_common
open Lib_crypto
module Migration_map = Map.Make (Int)

type t = Migration.t Migration_map.t

let equal = Migration_map.equal Migration.equal

let store_migration migrations_dir filepath ctx label given_index previous_hash =
  let open Effect in
  let* jsonm = read_migration_file_to_assoc migrations_dir filepath in
  match Migration.build given_index label filepath previous_hash jsonm with
  | Result.Error err -> error err
  | Result.Ok migration ->
    let+ () = info @@ Fmt.str "Storing file: %s in context" filepath in
    let hash = Migration.hash migration in
    Migration_map.add given_index migration ctx, (given_index, hash)
;;

let compute_migration migrations_dir previous current_migration =
  let open Effect in
  let* current_context, (previous_index, previous_hash) = previous in
  match current_migration with
  | Migration.Invalid_name_scheme { file = filepath } ->
    let+ () =
      warning @@ Fmt.str "Invalid name scheme: %s, file is ignored" filepath
    in
    current_context, (previous_index, previous_hash)
  | Migration.Valid_name_scheme { index = given_index; label; file = filepath }
    ->
    let expected_index = succ previous_index in
    if Int.equal expected_index given_index
    then
      store_migration
        migrations_dir
        filepath
        current_context
        label
        given_index
        previous_hash
    else error @@ Error.migration_invalid_successor ~expected_index ~given_index
;;

let init migrations_path =
  let open Effect in
  let* () = info @@ Fmt.str "Reading migration into %s" migrations_path in
  let* files = get_migrations_files migrations_path in
  let+ ctx, _ =
    List.fold_left
      (compute_migration migrations_path)
      (return (Migration_map.empty, (0, Sha256.neutral)))
      files
  in
  Try.ok ctx
;;

let to_list = Migration_map.bindings

let head ctx =
  ctx
  |> Migration_map.max_binding_opt
  |> Option.fold
       ~none:(0, Sha256.(to_string neutral))
       ~some:(fun (i, m) -> i, Sha256.to_string @@ Migration.hash m)
;;

let compute_forward ctx current target =
  ctx
  |> Migration_map.filter (fun i _ -> i > current && i <= target)
  |> Migration_map.bindings
  |> fun steps -> Plan.Forward steps
;;

let compute_backward ctx current target =
  let steps =
    ctx
    |> Migration_map.filter (fun i _ -> i > target && i <= current)
    |> Migration_map.bindings
    |> List.rev
  and state =
    Migration_map.find_opt target ctx
    |> Option.fold ~none:(0, Sha256.neutral) ~some:(fun m ->
         Migration.(m.index, hash m))
  in
  Plan.Backward (steps, state)
;;

let plan ~current ?target ctx =
  let max_index, _ = head ctx in
  let target = Option.value ~default:max_index target in
  if current > max_index
  then Error.(to_try @@ migration_invalid_state ~current_state:current)
  else if target > max_index
  then Error.(to_try @@ migration_invalid_target ~given_target:target)
  else if Int.equal current target
  then Ok Plan.Standby
  else
    Try.ok
      (if target > current
      then compute_forward ctx current target
      else compute_backward ctx current target)
;;

let valid_checksum given_index given_hash ctx =
  if given_index = 0 && String.equal given_hash Sha256.(to_string neutral)
  then Try.ok ()
  else (
    let none = Error.(to_try @@ migration_invalid_checksum ~given_index) in
    ctx
    |> Migration_map.find_opt given_index
    |> Option.fold ~none ~some:(fun x ->
         let stored_hash = Migration.hash x |> Sha256.to_string in
         if String.equal stored_hash given_hash then Try.ok () else none))
;;
