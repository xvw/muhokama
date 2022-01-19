type t =
  | With_message of string
  | Unknown

exception From_error of t

let pp f error =
  let ppf x = Format.fprintf f x in
  match error with
  | With_message msg -> ppf "With_message (%a)" Fmt.(quote string) msg
  | Unknown -> ppf "Unknown"
;;

let equal a b =
  match a, b with
  | With_message a, With_message b -> String.equal a b
  | Unknown, Unknown -> true
  | _ -> false
;;

module Set = struct
  module S = Set.Make (struct
    type nonrec t = t

    let compare a b =
      let x = Format.asprintf "%a" pp a
      and y = Format.asprintf "%a" pp b in
      String.compare x y
    ;;
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
