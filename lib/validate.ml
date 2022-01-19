type 'a t = ('a, Error.Set.t) Preface.Validation.t

let valid x = Preface.Validation.Valid x
let invalid x = Preface.Validation.Invalid (Error.Set.from_nonempty_list x)
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
module Monad = Preface.Validation.Monad (Error.Set)

let map = Functor.map
let apply = Applicative.apply
let bind = Monad.bind

module Infix = struct
  include Applicative.Infix
  include Monad.Infix
end

module Syntax = struct
  include Applicative.Syntax
  include Monad.Syntax
end

include (Infix : module type of Infix with type 'a t := 'a t)
include (Syntax : module type of Syntax with type 'a t := 'a t)
