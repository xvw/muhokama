type 'a t = ('a, Error.Set.t) Preface.Validation.t

let valid x = Preface.Validation.Valid x
let invalid x = Preface.Validation.Invalid x

let invalid_from_nel x =
  Preface.Validation.Invalid (Error.Set.from_nonempty_list x)
;;

let error x = Preface.Validation.Invalid (Error.Set.singleton x)

let pp pp_v ppf = function
  | Preface.Validation.Valid v ->
    Format.fprintf ppf "@[<2>Valid@ @[%a@]@]" pp_v v
  | Preface.Validation.Invalid e ->
    Format.fprintf ppf "@[<2>Invalid@ @[%a@]@]" Error.Set.pp e
;;

let equal eq a b =
  let open Preface.Validation in
  match a, b with
  | Valid x, Valid y -> eq x y
  | Invalid x, Invalid y -> Error.Set.equal x y
  | _ -> false
;;

module Functor = Preface.Validation.Functor (Error.Set)
module Applicative = Preface.Validation.Applicative (Error.Set)
module Alt = Preface.Validation.Alt (Error.Set)
module Monad = Preface.Validation.Monad (Error.Set)

let map = Functor.map
let apply = Applicative.apply
let bind = Monad.bind

module Infix = struct
  include Alt.Infix
  include Applicative.Infix
  include Monad.Infix

  let ( & ) = ( >=> )
end

module Syntax = struct
  include Applicative.Syntax
  include Monad.Syntax
end

include (Infix : module type of Infix with type 'a t := 'a t)
include (Syntax : module type of Syntax with type 'a t := 'a t)

let from_predicate ?(message = "The predicate is not validated") p x =
  if p x then valid x else error @@ Invalid_predicate message
;;

let greater_than min_bound x =
  let message = Fmt.str "[%d] is smaller or equal to [%d]" x min_bound in
  from_predicate ~message (fun x -> x > min_bound) x
;;

let smaller_than max_bound x =
  let message = Fmt.str "[%d] is greater or equal to [%d]" x max_bound in
  from_predicate ~message (fun x -> x < max_bound) x
;;

let bounded_to min_bound max_bound =
  let min = Int.min min_bound max_bound
  and max = Int.max min_bound max_bound in
  greater_than (pred min) & smaller_than (succ max)
;;

let not_empty =
  let message = "The given string is empty" in
  from_predicate ~message (function
      | "" -> false
      | _ -> true)
;;

let not_blank x =
  let message = Fmt.str "The given string, %a, is blank" Fmt.(quote string) x in
  from_predicate
    ~message
    (fun x ->
      match String.trim x with
      | "" -> false
      | _ -> true)
    x
;;

(* This a very weak implementation... *)
let is_email str =
  let message =
    Fmt.str "%a does not appear to be an email address" Fmt.(quote string) str
  in
  from_predicate
    ~message
    (fun x ->
      match String.split_on_char '@' x with
      | [ _; _ ] -> true
      | _ -> false)
    str
;;

let is_true x =
  let message = "The given boolean is false" in
  x |> from_predicate ~message (fun x -> x) |> Functor.replace ()
;;

let is_false x =
  let message = "The given boolean is false" in
  x |> from_predicate ~message (fun x -> not x) |> Functor.replace ()
;;

type key = string
type value = string

module Free = struct
  type 'a field =
    { validation : value option -> 'a t
    ; key : key
    }

  let map_validation = map

  include Preface.Make.Free_applicative.Over_functor (struct
    type 'a t = 'a field

    let map f field =
      { field with validation = (fun x -> f <$> field.validation x) }
    ;;
  end)

  module Run = To_applicative (Applicative)

  let run ?(provider = "data") fetch validate =
    let transform field =
      let value = fetch field.key in
      field.validation value
    in
    Run.run { transform } validate
    |> function
    | Preface.Validation.Valid x -> Ok x
    | Invalid err ->
      let errors = Error.Set.to_nonempty_list err in
      Error Error.(Invalid_provider { provider; errors })
  ;;

  let or_ prev default = prev <&> Option.value ~default
  let ( >? ) = or_

  let optional validator key =
    let validation = function
      | None -> valid None
      | Some value ->
        map_validation
          Option.some
          (validator value |> Error.collapse_for_field key)
    in
    promote { key; validation }
  ;;

  let required validator key =
    let validation = function
      | None -> error @@ Missing_field key
      | Some value -> validator value |> Error.collapse_for_field key
    in
    promote { key; validation }
  ;;

  let string = valid

  let int given_value =
    match int_of_string_opt given_value with
    | None -> error @@ Error.Invalid_projection { given_value; target = "int" }
    | Some x -> valid x
  ;;

  let bool given_value =
    match bool_of_string_opt given_value with
    | None -> error @@ Error.Invalid_projection { given_value; target = "bool" }
    | Some x -> valid x
  ;;
end
