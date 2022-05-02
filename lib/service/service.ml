type ('request, 'response) t =
  | Packed :
      { endpoint :
          ('method_, 'handler_function, 'request -> 'pre_response) Endpoint.t
      ; handler : 'handler_function
      ; hook : 'pre_response -> 'request -> 'response
      ; middlewares : (('request -> 'response) -> 'request -> 'response) list
      }
      -> ('request, 'response) t

let reduce_middlewares f middlewares =
  let rec aux = function
    | [] -> f
    | x :: xs -> x (aux xs)
  in
  aux middlewares
;;

let make ?(middlewares = []) endpoint hook handler =
  Packed { endpoint; middlewares; handler; hook }
;;

let regular ?middlewares endpoint handler =
  make endpoint ?middlewares (fun x _ -> x) handler
;;

let failable ?middlewares endpoint ~ok ~error handler =
  make
    endpoint
    ?middlewares
    (fun result request ->
      Lwt.bind result (function
          | Ok x -> ok x request
          | Error err -> error err request))
    handler
;;

let choose method_ given_uri services fallback request =
  let uri = Helper.sanitize_path given_uri |> List.rev in
  let rec aux = function
    | [] -> fallback request
    | Packed { endpoint; handler; middlewares; hook } :: xs ->
      let hooked_handler callback =
        let hooked req = hook (callback req) req in
        (reduce_middlewares hooked middlewares) request
      in
      (match Endpoint.handle endpoint method_ uri hooked_handler handler with
      | Some callback -> callback
      | None -> aux xs)
  in
  aux services
;;
