module L = Preface_stdlib.List.Applicative.Traversable (Validate.Applicative)

let valid f = f Validate.valid

let unexpected_repr expected_representation () =
  Error.(
    to_validate @@ validation_unexpected_representation ~expected_representation)
;;

let missing_field field () = Error.(to_validate @@ field_missing ~name:field)

module Make (A : Intf.AS_ASSOC) = struct
  type t = A.t

  let object_and k = A.as_object k @@ unexpected_repr "object"
  let object_ = valid object_and
  let list_and k = A.as_list k @@ unexpected_repr "list"
  let list = valid list_and
  let atom_and k = A.as_atom k @@ unexpected_repr "atom"
  let atom = valid atom_and
  let string_and k = A.as_string k @@ unexpected_repr "string"
  let string = valid string_and
  let bool_and k = A.as_bool k @@ unexpected_repr "bool"
  let bool = valid bool_and
  let int_and k = A.as_int k @@ unexpected_repr "int"
  let int = valid int_and
  let float_and k = A.as_float k @@ unexpected_repr "float"
  let float = valid float_and
  let null = A.as_null Validate.valid @@ unexpected_repr "null"

  let deep_equal f eq a b =
    f (fun x -> f (fun y -> eq x y) (Fun.const false) b) (Fun.const false) a
  ;;

  let rec equal a b =
    let open A in
    deep_equal as_null (fun () () -> true) a b
    || deep_equal as_atom String.equal a b
    || deep_equal as_string String.equal a b
    || deep_equal as_bool Bool.equal a b
    || deep_equal as_int Int.equal a b
    || deep_equal as_float Float.equal a b
    || deep_equal as_list (List.equal equal) a b
    || deep_equal
         as_object
         (List.equal (fun (k, y) (k', y') -> String.equal k k' && equal y y'))
         a
         b
  ;;

  let list_of k s =
    list_and
      (fun list ->
        list
        |> L.traverse k
        |> function
        | Preface.Validation.Invalid _ ->
          unexpected_repr "list is not monomorphic" ()
        | mono_list -> mono_list)
      s
  ;;

  let optional f key assoc =
    let open Validate in
    match List.assoc_opt key assoc with
    | None -> valid None
    | Some value ->
      A.as_null
        (fun () -> valid None)
        (fun () -> Option.some <$> (f value |> Error.collapse_for_field key))
        value
  ;;

  let required f key assoc =
    match List.assoc_opt key assoc with
    | None -> missing_field key ()
    | Some value ->
      A.as_null
        (missing_field key)
        (fun () -> f value |> Error.collapse_for_field key)
        value
  ;;

  let ensure_equality key_a key_b assoc =
    let message =
      Fmt.str
        "fields %a and %a are not equivalent"
        Fmt.(quote string)
        key_a
        Fmt.(quote string)
        key_b
    and a = List.assoc_opt key_a assoc
    and b = List.assoc_opt key_b assoc in
    (if Option.equal equal a b
    then Validate.valid ()
    else
      Error.(to_validate @@ validation_invalid_predicate ~with_message:message))
    |> Error.collapse_for_field key_a
  ;;

  let or_ prev default =
    let open Validate in
    prev <&> Option.value ~default
  ;;

  let ( >? ) = or_

  let from_urlencoded l =
    let r =
      List.map
        (fun (k, vs) ->
          ( k
          , match vs with
            | [] -> A.to_null (fun _ -> assert false) None
            | [ x ] -> A.to_string x
            | xs -> A.to_list (List.map (fun x -> A.to_string x) xs) ))
        l
    in
    A.to_object r
  ;;

  let run ?(name = "data") validated =
    match validated with
    | Preface.Validation.Valid x -> Ok x
    | Invalid errors -> Error.(to_try @@ invalid_object ~name ~errors)
  ;;
end

module Yojson = struct
  type t =
    [ `Null
    | `Bool of bool
    | `Int of int
    | `Intlit of string
    | `Float of float
    | `Floatlit of string
    | `String of string
    | `Stringlit of string
    | `Assoc of (string * t) list
    | `List of t list
    | `Tuple of t list
    | `Variant of string * t option
    ]

  module A = struct
    type nonrec t = t

    let as_object valid invalid = function
      | `Assoc kv -> valid kv
      | _ -> invalid ()
    ;;

    let to_object l = `Assoc l

    let as_list valid invalid = function
      | `List v -> valid v
      | _ -> invalid ()
    ;;

    let to_list l = `List l
    let as_atom _valid invalid _ = invalid ()
    let to_atom s = `Stringlit s

    let as_string valid invalid = function
      | `String s -> valid s
      | _ -> invalid ()
    ;;

    let to_string s = `String s

    let as_bool valid invalid = function
      | `Bool b -> valid b
      | _ -> invalid ()
    ;;

    let to_bool b = `Bool b

    let as_int valid invalid = function
      | `Int i -> valid i
      | _ -> invalid ()
    ;;

    let to_int i = `Int i

    let as_float valid invalid = function
      | `Float f -> valid f
      | _ -> invalid ()
    ;;

    let to_float f = `Float f

    let as_null valid invalid = function
      | `Null -> valid ()
      | _ -> invalid ()
    ;;

    let to_null f = function
      | Some x -> f x
      | None -> `Null
    ;;
  end

  module V = Make (A)
  include (A : Intf.AS_ASSOC with type t := t)
  include (V : Intf.VALIDABLE_ASSOC with type t := t)
end

module Jsonm = struct
  type t =
    [ `Null
    | `Bool of bool
    | `Float of float
    | `String of string
    | `A of t list
    | `O of (string * t) list
    ]

  module A = struct
    type nonrec t = t

    let as_object valid invalid = function
      | `O kv -> valid kv
      | _ -> invalid ()
    ;;

    let to_object l = `O l

    let as_list valid invalid = function
      | `A v -> valid v
      | _ -> invalid ()
    ;;

    let to_list l = `A l
    let as_atom _valid invalid _ = invalid ()
    let to_atom s = `String s

    let as_string valid invalid = function
      | `String s -> valid s
      | _ -> invalid ()
    ;;

    let to_string s = `String s

    let as_bool valid invalid = function
      | `Bool b -> valid b
      | _ -> invalid ()
    ;;

    let to_bool b = `Bool b

    let as_int valid invalid = function
      | `Float f -> valid @@ int_of_float f
      | _ -> invalid ()
    ;;

    let to_int i = `Float (float_of_int i)

    let as_float valid invalid = function
      | `Float f -> valid f
      | _ -> invalid ()
    ;;

    let to_float f = `Float f

    let as_null valid invalid = function
      | `Null -> valid ()
      | _ -> invalid ()
    ;;

    let to_null f = function
      | Some x -> f x
      | None -> `Null
    ;;
  end

  module V = Make (A)
  include (A : Intf.AS_ASSOC with type t := t)
  include (V : Intf.VALIDABLE_ASSOC with type t := t)
end
