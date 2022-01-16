type 'a field =
  { validation : string option -> 'a Preface.Validate.t
  ; key : string
  }

module Functor = Preface.Make.Functor.Via_map (struct
  type 'a t = 'a field

  let map f field =
    let open Preface.Validate.Functor in
    { field with validation = (fun x -> f <$> field.validation x) }
  ;;
end)

include Preface.Make.Free_applicative.Over_functor (Functor)
module Run = To_applicative (Preface.Validate.Applicative)

let ( & ) f g = Preface.Validate.Monad.(f >=> g)

let handle_errors key = function
  | Preface.Validation.Valid x -> Preface.Validation.Valid x
  | Preface.Validation.Invalid errors ->
    let exn = Exn.(Invalid_field { key; errors }) in
    Exn.as_validation exn
;;

let optional f key =
  let validation =
    let open Preface.Validate in
    function
    | None -> valid None
    | Some value -> Functor.(Option.some <$> (f value |> handle_errors key))
  in
  promote { key; validation }
;;

let required f key =
  let validation = function
    | None -> Exn.(as_validation @@ Required_field key)
    | Some value -> f value |> handle_errors key
  in
  promote { key; validation }
;;

let int x =
  match int_of_string_opt x with
  | None ->
    Exn.(
      as_validation
      @@ Unexpected_value { expected_type = "int"; given_value = x })
  | Some given_value -> Preface.Validate.valid given_value
;;

let string x = Preface.Validate.valid x

let greater_than min_bound given_value =
  if given_value > min_bound
  then Preface.Validate.valid given_value
  else Exn.(as_validation @@ Int_too_small { given_value; min_bound })
;;

let smaller_than max_bound given_value =
  if given_value < max_bound
  then Preface.Validate.valid given_value
  else Exn.(as_validation @@ Int_too_large { given_value; max_bound })
;;

let bounded min_bound max_bound =
  let min = Int.min min_bound max_bound
  and max = Int.max min_bound max_bound in
  greater_than (pred min) & smaller_than (succ max)
;;

let not_empty = function
  | "" -> Exn.(as_validation String_is_empty)
  | str -> Preface.Validate.valid str
;;

let not_blank given_value =
  match String.trim given_value with
  | "" -> Exn.(as_validation @@ String_is_blank given_value)
  | _ -> Preface.Validate.valid given_value
;;

let run fetch validate =
  Run.run
    { transform =
        (fun field ->
          let r = fetch field.key in
          field.validation r)
    }
    validate
;;
