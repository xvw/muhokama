type _ variable =
  | String : string variable
  | Int : int variable
  | Char : char variable
  | Float : float variable
  | Bool : bool variable

type (_, _) path =
  | Root : ('handler_return, 'handler_return) path
  | Constant :
      ('handler_function, 'handler_return) path * string
      -> ('handler_function, 'handler_return) path
  | Variable :
      ('handler_function, 'new_variable -> 'handler_return) path
      * 'new_variable variable
      -> ('handler_function, 'handler_return) path

let variable_to_string : type a. a -> a variable -> string =
 fun x -> function
  | String -> x
  | Int -> string_of_int x
  | Char -> String.make 1 x
  | Float -> string_of_float x
  | Bool -> string_of_bool x
;;

let variable_from_string : type a. string -> a variable -> a option =
 fun x -> function
  | String -> Some x
  | Int -> int_of_string_opt x
  | Char -> if Int.equal (String.length x) 1 then Some x.[0] else None
  | Float -> float_of_string_opt x
  | Bool -> bool_of_string_opt x
;;

let root = Root
let string = String
let int = Int
let char = Char
let float = Float
let bool = Bool
let ( / ) left value = Constant (left, value)
let ( /: ) left variable = Variable (left, variable)
let ( ~/ ) value = root / value
let ( ~/: ) variable = root /: variable

let handle_path_link path handler =
  let rec aux : type a b. (string list -> b) -> (a, b) path -> a =
   fun continue -> function
    | Root -> continue []
    | Constant (tail, x) -> aux (fun xs -> continue (x :: xs)) tail
    | Variable (tail, w) ->
      let next xs param =
        let x = variable_to_string param w in
        continue (x :: xs)
      in
      aux next tail
  in
  aux
    (fun x ->
      let str = "/" ^ String.concat "/" @@ List.rev x in
      handler str)
    path
;;

let handle_path_for path uri handler =
  let rec aux
      : type a b c. (b -> c) -> (a, b) path -> string list -> a -> c option
    =
   fun continue path uri ->
    match path, uri with
    | Root, [] -> fun x -> Some (continue x)
    | Constant (tail, value), fragment :: xs ->
      if String.equal value fragment
      then aux continue tail xs
      else fun _ -> None
    | Variable (tail, w), fragment :: xs ->
      (match variable_from_string fragment w with
      | None -> fun _ -> None
      | Some var -> aux (fun acc -> continue (acc var)) tail xs)
    | _ -> fun _ -> None
  in
  aux handler path uri
;;

type method_ =
  [ `GET
  | `POST
  | `PUT
  | `DELETE
  | `HEAD
  | `CONNECT
  | `OPTIONS
  | `TRACE
  | `PATCH
  | `Method of string
  ]

type (_, _, _) t =
  | GET :
      ('handler_function, 'handler_return) path
      -> ([ `GET ], 'handler_function, 'handler_return) t
  | POST :
      ('handler_function, 'handler_return) path
      -> ([ `POST ], 'handler_function, 'handler_return) t

let get path = GET path
let post path = POST path

let path_of
    : type method_.
      (method_, 'handler_function, 'handler_return) t
      -> ('handler_function, 'handler_return) path
  = function
  | GET p | POST p -> p
;;

let handle_link endpoint handler =
  let path = path_of endpoint in
  handle_path_link path handler
;;

let href = function
  | GET path -> handle_path_link path Fun.id
;;

let redirect ?status ?code ?headers = function
  | GET path ->
    handle_path_link path (fun target request ->
        Dream.redirect ?status ?code ?headers request target)
;;

let form_method : type method_. (method_, _, _) t -> _ = function
  | GET _ -> `Get
  | POST _ -> `Post
;;

let form_action endpoint = handle_link endpoint Fun.id

let form_method_action endpoint =
  handle_link endpoint (fun link -> form_method endpoint, link)
;;

let handle endpoint given_method given_uri handler =
  let aux
      : type endpoint_method.
        (endpoint_method, 'handler_function, 'handler_return) t -> _
    =
   fun endpoint ->
    match endpoint, given_method with
    | GET path, `GET -> handle_path_for path given_uri handler
    | POST path, `POST -> handle_path_for path given_uri handler
    | _ -> fun _ -> None
  in
  aux endpoint
;;
