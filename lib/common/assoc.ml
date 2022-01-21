module L = Preface_stdlib.List.Applicative.Traversable (Validate.Applicative)

let valid f = f Validate.valid

let unexpected_repr expected_repr () =
  Validate.error @@ Error.Unexpected_repr { expected_repr }
;;

let missing_field field () = Validate.error @@ Error.Missing_field field

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
    let open Validate in
    match List.assoc_opt key assoc with
    | None -> error @@ Missing_field key
    | Some value ->
      A.as_null
        (missing_field key)
        (fun () -> f value |> Error.collapse_for_field key)
        value
  ;;

  let or_ prev default =
    let open Validate in
    prev <&> Option.value ~default
  ;;

  let ( >? ) = or_

  let run ?(provider = "data") validated =
    match validated with
    | Preface.Validation.Valid x -> Ok x
    | Invalid err ->
      let errors = Error.Set.to_nonempty_list err in
      Error Error.(Invalid_provider { provider; errors })
  ;;
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

    let as_list valid invalid = function
      | `A v -> valid v
      | _ -> invalid ()
    ;;

    let as_atom _valid invalid _ = invalid ()

    let as_string valid invalid = function
      | `String s -> valid s
      | _ -> invalid ()
    ;;

    let as_bool valid invalid = function
      | `Bool b -> valid b
      | _ -> invalid ()
    ;;

    let as_int valid invalid = function
      | `Float f -> valid @@ int_of_float f
      | _ -> invalid ()
    ;;

    let as_float valid invalid = function
      | `Float f -> valid f
      | _ -> invalid ()
    ;;

    let as_null valid invalid = function
      | `Null -> valid ()
      | _ -> invalid ()
    ;;
  end

  module V = Make (A)
  include (A : Intf.AS_ASSOC with type t := t)
  include (V : Intf.VALIDABLE_ASSOC with type t := t)
end
