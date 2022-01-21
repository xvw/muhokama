type t =
  | Invalid_field of
      { key : string
      ; errors : t Preface.Nonempty_list.t
      }
  | Invalid_provider of
      { provider : string
      ; errors : t Preface.Nonempty_list.t
      }
  | Invalid_projection of
      { given_value : string
      ; target : string
      }
  | Unexpected_repr of { expected_repr : string }
  | Missing_field of string
  | Invalid_predicate of string
  | With_message of string
  | Invalid_log_level of string
  | Database of string
  | Unknown

exception From_error of t

let rec pp f error =
  let ppf x = Format.fprintf f x in
  match error with
  | Invalid_field { key; errors } ->
    ppf
      "Invalid_field {key = %a; errors = %a }"
      Fmt.(quote string)
      key
      (Preface.Nonempty_list.pp pp)
      errors
  | Invalid_provider { provider; errors } ->
    ppf
      "Invalid_provider {provider = %a; errors = %a }"
      Fmt.(quote string)
      provider
      (Preface.Nonempty_list.pp pp)
      errors
  | Invalid_projection { given_value; target } ->
    ppf
      "Invalid_projection { given_value = %a; target = %a }"
      Fmt.(quote string)
      given_value
      Fmt.(quote string)
      target
  | Invalid_predicate msg -> ppf "Invalid_predicate %a" Fmt.(quote string) msg
  | Missing_field field -> ppf "Missing_field %a" Fmt.(quote string) field
  | With_message msg -> ppf "With_message %a" Fmt.(quote string) msg
  | Invalid_log_level level ->
    ppf "Invalid_log_level %a" Fmt.(quote string) level
  | Database msg -> ppf "Database %a" Fmt.(quote string) msg
  | Unexpected_repr { expected_repr } ->
    ppf
      "Unexpected_repr { expected_repr = %a }"
      Fmt.(quote string)
      expected_repr
  | Unknown -> ppf "Unknown"
;;

let rec equal a b =
  match a, b with
  | Invalid_field a, Invalid_field b ->
    String.equal a.key b.key
    && Preface.Nonempty_list.equal equal a.errors b.errors
  | Invalid_provider a, Invalid_provider b ->
    String.equal a.provider b.provider
    && Preface.Nonempty_list.equal equal a.errors b.errors
  | Missing_field a, Missing_field b -> String.equal a b
  | Invalid_predicate a, Invalid_predicate b -> String.equal a b
  | Invalid_projection a, Invalid_projection b ->
    String.equal a.given_value b.given_value && String.equal a.target b.target
  | With_message a, With_message b -> String.equal a b
  | Invalid_log_level a, Invalid_log_level b -> String.equal a b
  | Database a, Database b -> String.equal a b
  | Unexpected_repr { expected_repr = a }, Unexpected_repr { expected_repr = b }
    -> String.equal a b
  | Unknown, Unknown -> true
  | _ -> false
;;

module Set = struct
  module S = Set.Make (struct
    type nonrec t = t

    let compare a b = if equal a b then 0 else 1
  end)

  let singleton = S.singleton
  let from_nonempty_list list = Preface.Nonempty_list.to_list list |> S.of_list
  let equal = S.equal
  let pp ppf x = Format.fprintf ppf "Set[%a]" (Fmt.seq pp) (S.to_seq x)

  let to_nonempty_list set =
    S.fold
      (fun x ->
        let open Preface.Nonempty_list in
        function
        | None -> Some (create x)
        | Some xs -> Some (cons x xs))
      set
      None
    |> function
    | None -> assert false (* Never reachable*)
    | Some x -> Preface.Nonempty_list.rev x
  ;;

  include Preface.Make.Semigroup.Via_combine (struct
    type t = S.t

    let combine = S.union
  end)
end

let to_exn e = From_error e
let to_try e = Preface.Result.Error e
let to_validate e = Preface.(Validation.Invalid (Set.singleton e))

let collapse_for_field key = function
  | Preface.Validation.Valid x -> Preface.Validation.valid x
  | Invalid err ->
    let errors = Set.to_nonempty_list err in
    Preface.Validation.invalid @@ Set.singleton (Invalid_field { key; errors })
;;
