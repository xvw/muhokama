(** The association interfaces allow to validate data structured in key-values
    more or less generically and the implementation is freely inspired by the
    technique presented in {{:https://xhtmlboi.github.io/articles/yocaml.html}
    this article}. *)

module Make (A : Intf.AS_ASSOC) : Intf.VALIDABLE_ASSOC with type t = A.t

module Jsonm : sig
  type t =
    [ `Null
    | `Bool of bool
    | `Float of float
    | `String of string
    | `A of t list
    | `O of (string * t) list
    ]

  include Intf.AS_ASSOC with type t := t
  include Intf.VALIDABLE_ASSOC with type t := t
end
