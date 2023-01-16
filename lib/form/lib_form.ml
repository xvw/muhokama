open Lib_common
module VO = Validate.Applicative.Traversable (Preface.Option.Applicative)
module OV = Preface.Option.Applicative.Traversable (Validate.Applicative)

type 'a validated = 'a Validate.t
type ('a, 'b) validator = 'a -> 'b validated

let from_predicate = Validate.from_predicate

let unconvertible given_value target_type =
  let open Error in
  to_validate @@ validation_unconvertible_string ~given_value ~target_type
;;

let is_string = Validate.valid

let is_int given_value =
  given_value
  |> int_of_string_opt
  |> Option.fold ~none:(unconvertible given_value "int") ~some:Validate.valid
;;

let is_float given_value =
  given_value
  |> float_of_string_opt
  |> Option.fold ~none:(unconvertible given_value "float") ~some:Validate.valid
;;

let is_bool given_value =
  given_value
  |> bool_of_string_opt
  |> Option.fold ~none:(unconvertible given_value "bool") ~some:Validate.valid
;;

let is_email = Validate.is_email

let is_uuid_char c =
  (Char.code c >= 97 && Char.code c <= 122)
  || (Char.code c >= 48 && Char.code c <= 57)
;;

let is_potential_url value =
  let uri = Uri.of_string value in
  match Uri.scheme uri with
  | Some "http" | Some "https" -> Validate.valid uri
  | _ -> unconvertible value "url"
;;

let check_uuid_part v s =
  String.(Int.equal (length v) s && for_all is_uuid_char v)
;;

let is_uuid x =
  let message = Fmt.str "%a seems not be a UUID" Fmt.(quote string) x in
  from_predicate
    ~message
    (fun x ->
      match String.split_on_char '-' x with
      | [ a8; b4; c4; d4; e12 ] ->
        check_uuid_part a8 8
        && check_uuid_part b4 4
        && check_uuid_part c4 4
        && check_uuid_part d4 4
        && check_uuid_part e12 12
      | _ -> false)
    x
;;

let greater_than = Validate.greater_than
let smaller_than = Validate.smaller_than
let bounded_to = Validate.bounded_to
let not_empty = Validate.not_empty
let not_blank = Validate.not_blank
let is_true = Validate.is_true
let is_false = Validate.is_false
let run_validator f x = f x

let optional assoc key f =
  let open Validate in
  assoc
  |> List.assoc_opt key
  |> Option.(
       fold ~none:(valid None) ~some:(fun value ->
         Option.some <$> (f value |> Error.collapse_for_field key)))
;;

let required assoc key f =
  assoc
  |> List.assoc_opt key
  |> Option.fold
       ~none:Error.(to_validate @@ field_missing ~name:key)
       ~some:(fun value -> f value |> Error.collapse_for_field key)
;;

let ensure_equality assoc key_a key_b =
  let message =
    Fmt.str
      "fields %a and %a are note equivalent"
      Fmt.(quote string)
      key_a
      Fmt.(quote string)
      key_b
  and a = List.assoc_opt key_a assoc
  and b = List.assoc_opt key_b assoc in
  let result =
    match Option.equal String.equal a b with
    | true -> Validate.valid ()
    | false ->
      Error.(to_validate @@ validation_invalid_predicate ~with_message:message)
  in
  result |> Error.collapse_for_field key_a
;;

let ( &> ) = Validate.Monad.compose_left_to_right
let ( <|> ) a b x = Validate.Alt.combine (a x) (b x)
let ( $ ) a f x = Validate.map f (a x)

let ( &? ) a b x =
  let open Validate in
  a x >>= Option.fold ~none:(valid None) ~some:(fun x -> Option.some <$> b x)
;;

let ( <?> ) a b x =
  let open Validate in
  a x >>= Option.fold ~none:(b x) ~some:(fun x -> valid @@ Some x)
;;

let ( & ) a b =
  let open Validate in
  let+ a = a
  and+ b = b in
  a, b
;;

let ( let+ ) = Validate.( let+ )
let ( and+ ) = Validate.( and+ )

let run ?(name = "form") f x =
  match f x with
  | Preface.Validation.Valid x -> Try.ok x
  | Preface.Validation.Invalid errors ->
    Error.(to_try @@ invalid_form ~name ~errors)
;;
