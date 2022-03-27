module Nel = Preface.Nonempty_list

type 'a t = ('a, Error.t Nel.t) Preface.Validation.t

let valid x = Preface.Validation.Valid x
let invalid x = Preface.Validation.Invalid x
let error x = Error.to_validate x

let pp pp_v ppf = function
  | Preface.Validation.Valid v ->
    Format.fprintf ppf "@[<2>Valid@ @[%a@]@]" pp_v v
  | Preface.Validation.Invalid e ->
    Format.fprintf
      ppf
      "@[<2>Invalid@ @[%a@]@]"
      (Fmt.list Error.pp)
      (Nel.to_list e)
;;

let equal eq a b =
  let open Preface.Validation in
  match a, b with
  | Valid x, Valid y -> eq x y
  | Invalid x, Invalid y -> Nel.equal Error.equal x y
  | _ -> false
;;

module E = Preface.Make.Semigroup.From_alt (Nel.Alt) (Error)
module Functor = Preface.Validation.Functor (E)
module Applicative = Preface.Validation.Applicative (E)
module Alt = Preface.Validation.Alt (E)
module Monad = Preface.Validation.Monad (E)

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

include Infix
include Syntax

let from_predicate ?(message = "The predicate is not validated") p x =
  if p x
  then valid x
  else error @@ Error.validation_invalid_predicate ~with_message:message
;;

let greater_than min_bound given_value =
  if given_value <= min_bound
  then error @@ Error.validation_is_smaller_than ~min_bound ~given_value
  else valid given_value
;;

let smaller_than max_bound given_value =
  if given_value >= max_bound
  then error @@ Error.validation_is_greater_than ~max_bound ~given_value
  else valid given_value
;;

let bounded_to min_bound max_bound =
  let min = Int.min min_bound max_bound
  and max = Int.max min_bound max_bound in
  greater_than (pred min) & smaller_than (succ max)
;;

let not_empty s =
  match s with
  | "" -> Error.(to_validate validation_is_empty)
  | _ -> valid s
;;

let not_blank x =
  match String.trim x with
  | "" -> Error.(to_validate validation_is_blank)
  | _ -> valid x
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

  let run ?(name = "data") fetch validate =
    let transform field =
      let value = fetch field.key in
      field.validation value
    in
    Run.run { transform } validate
    |> function
    | Preface.Validation.Valid x -> Ok x
    | Invalid errors -> Error Error.(Invalid_object { name; errors })
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
      | None -> error @@ Error.field_missing ~name:key
      | Some value -> validator value |> Error.collapse_for_field key
    in
    promote { key; validation }
  ;;

  let string = valid

  let int given_value =
    match int_of_string_opt given_value with
    | None ->
      error
      @@ Error.validation_unconvertible_string ~given_value ~target_type:"int"
    | Some x -> valid x
  ;;

  let bool given_value =
    match bool_of_string_opt given_value with
    | None ->
      error
      @@ Error.validation_unconvertible_string ~given_value ~target_type:"bool"
    | Some x -> valid x
  ;;
end
