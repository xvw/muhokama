type _ witness =
  | String : string witness
  | Int : int witness
  | Char : char witness
  | Float : float witness
  | Bool : bool witness

type (_, _) t =
  | Root : ('a, 'a) t
  | Const : int * ('a, 'b) t * string -> ('a, 'b) t
  | Param : int * ('a, 'c -> 'b) t * 'c witness -> ('a, 'b) t

let tick : type a b. (a, b) t -> int = function
  | Root -> 1
  | Const (x, _, _) -> x
  | Param (x, _, _) -> succ x
;;

let witness_to_string
    : type a. ?need_prefix:string -> int -> a witness -> string
  =
 fun ?need_prefix tick ->
  let tick_str = string_of_int tick in
  let prefix = Option.value ~default:"" need_prefix in
  let var v = prefix ^ v ^ "_" ^ tick_str in
  function
  | String -> var "string"
  | Int -> var "int"
  | Char -> var "char"
  | Float -> var "float"
  | Bool -> var "bool"
;;

let param_to_string : type a. a witness -> a -> string =
 fun witness value ->
  match witness with
  | String -> value
  | Int -> string_of_int value
  | Char -> String.make 1 value
  | Float -> string_of_float value
  | Bool -> string_of_bool value
;;

let param_from_string : type a. a witness -> string -> a =
 fun witness value ->
  match witness with
  | String -> value
  | Int -> int_of_string value
  | Char -> value.[0]
  | Float -> float_of_string value
  | Bool -> bool_of_string value
;;

let string = String
let int = Int
let char = Char
let float = Float
let bool = Bool
let ( / ) previous elt = Const (tick previous, previous, elt)
let ( /: ) previous elt = Param (tick previous, previous, elt)
let ( ! ) elt = Root / elt
let ( !: ) elt = Root /: elt
let root = Root

let to_route path =
  let rec aux : type a b. string list -> (a, b) t -> string list =
   fun acc -> function
    | Root -> "" :: acc
    | Const (_, previous, value) -> aux (value :: acc) previous
    | Param (tick, previous, witness) ->
      let param_str = witness_to_string ~need_prefix:":" tick witness in
      aux (param_str :: acc) previous
  in
  aux [] path |> String.concat "/"
;;

let to_string path =
  let rec aux : type a b. (string -> b) -> (a, b) t -> a =
   fun k -> function
    | Root -> k ""
    | Const (_, previous, const) ->
      aux (fun acc -> k (acc ^ "/" ^ const)) previous
    | Param (_, previous, witness) ->
      aux
        (fun acc param ->
          let param_str = param_to_string witness param in
          k (acc ^ "/" ^ param_str))
        previous
  in
  aux Fun.id path
;;

let handle get_param path =
  let rec aux : type a b c. (b -> c) -> (a, b) t -> a -> c =
   fun k -> function
    | Root -> k
    | Const (_, previous, _) -> aux k previous
    | Param (tick, previous, witness) ->
      let key = witness_to_string tick witness in
      let prm = get_param key in
      let cnv = param_from_string witness prm in
      aux (fun f -> k (f cnv)) previous
  in
  aux Fun.id path
;;

let handle_with uri path =
  let rec aux : type a b c. (b -> c) -> (a, b) t -> string list -> a -> c option
    =
   fun k path uri ->
    match path, uri with
    | Root, [] -> fun x -> Some (k x)
    | Root, _ :: _ -> fun _ -> None
    | Const (_, previous, value), fragment :: xs ->
      if String.equal value fragment then aux k previous xs else fun _ -> None
    | Param (_, previous, witness), fragment :: xs ->
      (try
         let cnv = param_from_string witness fragment in
         aux (fun f -> k (f cnv)) previous xs
       with
      | _ -> fun _ -> None)
    | _, [] -> fun _ -> None
  in
  aux Fun.id path (List.rev @@ Helper.sanitize_path uri)
;;
