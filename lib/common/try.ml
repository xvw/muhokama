type 'a t = ('a, Error.t) result

let ok x = Ok x
let error x = Error x
let pp ok = Fmt.result ~ok ~error:Error.pp

let equal eq a b =
  match a, b with
  | Error x, Error y -> Error.equal x y
  | Ok x, Ok y -> eq x y
  | _ -> false
;;

module Functor = Preface.Result.Functor (Error)
module Applicative = Preface.Result.Applicative (Error)
module Monad = Preface.Result.Monad (Error)

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
