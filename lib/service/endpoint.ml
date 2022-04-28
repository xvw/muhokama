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

type (_, _, _, 'request, 'response) t =
  | GET :
      { path : unit -> ('a, 'b) Path.t
      ; middlewares : (('request -> 'response) -> 'request -> 'response) list
      }
      -> ([ `GET ], 'a, 'b, 'request, 'response) t
  | POST :
      { path : unit -> ('a, 'b) Path.t
      ; middlewares : (('request -> 'response) -> 'request -> 'response) list
      }
      -> ([ `POST ], 'a, 'b, 'request, 'response) t

type ('normal_form, 'request, 'response) route =
  | R :
      ('meth, 'continuation, 'normal_form, 'request, 'response) t
      * 'continuation
      -> ('normal_form, 'request, 'response) route

let get path middlewares () = GET { path; middlewares }
let post path middlewares () = POST { path; middlewares }
let route endpoint handler = R (endpoint, handler)

let middlewares : type meth. (meth, 'a, 'b, 'request, 'response) t -> _
  = function
  | GET { middlewares; _ } -> middlewares
  | POST { middlewares; _ } -> middlewares
;;

let collapse_middlewares endpoint f =
  let rec aux = function
    | [] -> f
    | g :: xs -> g (aux xs)
  in
  aux (middlewares endpoint)
;;

let href = function
  | GET { path; _ } -> Path.to_string @@ path ()
;;

let method_ : type meth. (meth, 'a, 'b, 'request, 'response) t -> _ = function
  | GET _ -> `Get
  | POST _ -> `Post
;;

let action : type meth. (meth, 'a, 'b, 'request, 'response) t -> _ =
 fun endpoint ->
  match endpoint with
  | GET { path; _ } -> Path.to_string @@ path ()
  | POST { path; _ } -> Path.to_string @@ path ()
;;

let handle given_method uri endpoint =
  let aux : type meth. (meth, 'a, 'b, 'request, 'response) t -> _ =
   fun endpoint ->
    match endpoint, given_method with
    | GET { path; _ }, `GET -> Path.handle_with uri @@ path ()
    | POST { path; _ }, `POST -> Path.handle_with uri @@ path ()
    | _ -> fun _ -> None
  in
  aux endpoint
;;

let decide routes given_method uri continue request =
  let rec aux = function
    | [] -> continue request
    | R (endpoint, handler) :: xs ->
      (match handle given_method uri endpoint handler with
      | Some x -> (collapse_middlewares endpoint x) request
      | None -> aux xs)
  in
  aux routes
;;
