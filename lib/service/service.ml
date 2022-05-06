type ('request, 'response) handler = 'request -> 'response Lwt.t

type ('request, 'response) middleware =
  ('request, 'response) handler -> ('request, 'response) handler

type ('request, 'response) middlewares = ('request, 'response) middleware list

type ('method_, 'handler_function, 'request, 'response) straight =
  { endpoint :
      ('method_, 'handler_function, ('request, 'response) handler) Endpoint.t
  ; middlewares : ('request, 'response) middlewares
  ; handler : 'handler_function
  }

type ('method_
     , 'handler_function
     , 'attachment
     , 'request
     , 'response)
     straight_with_attachment =
  { endpoint :
      ( 'method_
      , 'handler_function
      , 'attachment -> ('request, 'response) handler )
      Endpoint.t
  ; middlewares : ('request, 'response) middlewares
  ; attached :
      ('attachment -> ('request, 'response) handler)
      -> ('request, 'response) handler
  ; handler : 'handler_function
  }

type ('method_
     , 'handler_function
     , 'result
     , 'error
     , 'request
     , 'response)
     failable =
  { endpoint :
      ( 'method_
      , 'handler_function
      , ('request, ('result, 'error) result) handler )
      Endpoint.t
  ; middlewares : ('request, 'response) middlewares
  ; succeed_callback : 'result -> ('request, 'response) handler
  ; failure_callback : 'error -> ('request, 'response) handler
  ; handler : 'handler_function
  }

type ('method_
     , 'handler_function
     , 'attachment
     , 'result
     , 'error
     , 'request
     , 'response)
     failable_with_attachment =
  { endpoint :
      ( 'method_
      , 'handler_function
      , 'attachment -> ('request, ('result, 'error) result) handler )
      Endpoint.t
  ; middlewares : ('request, 'response) middlewares
  ; succeed_callback : 'result -> ('request, 'response) handler
  ; failure_callback : 'error -> ('request, 'response) handler
  ; attached :
      ('attachment -> ('request, 'response) handler)
      -> ('request, 'response) handler
  ; handler : 'handler_function
  }

type ('request, 'response) t =
  | Straight :
      ('method_, 'handler_function, 'request, 'response) straight
      -> ('request, 'response) t
  | Straight_attached :
      ( 'method_
      , 'handler_function
      , 'attachment
      , 'request
      , 'response )
      straight_with_attachment
      -> ('request, 'response) t
  | Failable :
      ( 'method_
      , 'handler_function
      , 'result
      , 'error
      , 'request
      , 'response )
      failable
      -> ('request, 'response) t
  | Failable_with_attachment :
      ( 'method_
      , 'handler_function
      , 'attachment
      , 'result
      , 'error
      , 'request
      , 'response )
      failable_with_attachment
      -> ('request, 'response) t

let straight endpoint middlewares handler =
  Straight { endpoint; middlewares; handler }
;;

let straight_with ~attached endpoint middlewares handler =
  Straight_attached { endpoint; attached; middlewares; handler }
;;

let failable endpoint middlewares ~succeed ~failure handler =
  Failable
    { endpoint
    ; middlewares
    ; succeed_callback = succeed
    ; failure_callback = failure
    ; handler
    }
;;

let failable_with ~attached endpoint middlewares ~succeed ~failure handler =
  Failable_with_attachment
    { endpoint
    ; attached
    ; middlewares
    ; succeed_callback = succeed
    ; failure_callback = failure
    ; handler
    }
;;

let reduce_middlewares f middlewares =
  let rec aux = function
    | [] -> f
    | x :: xs -> x (aux xs)
  in
  aux middlewares
;;

let choose method_ given_uri services fallback request =
  let uri = Helper.sanitize_path given_uri |> List.rev in
  let rec aux = function
    | [] -> fallback request
    | Straight { endpoint; middlewares; handler } :: services ->
      (match Endpoint.handle endpoint method_ uri Fun.id handler with
      | Some handler -> (reduce_middlewares handler middlewares) request
      | None -> aux services)
    | Straight_attached { endpoint; middlewares; handler; attached } :: services
      ->
      (match Endpoint.handle endpoint method_ uri Fun.id handler with
      | Some callback ->
        let inner_handler request = attached callback request in
        (reduce_middlewares inner_handler middlewares) request
      | None -> aux services)
    | Failable
        { endpoint; handler; middlewares; succeed_callback; failure_callback }
      :: services ->
      (match Endpoint.handle endpoint method_ uri Fun.id handler with
      | Some callback ->
        let full_handler request =
          Lwt.bind (callback request) (function
              | Ok x -> succeed_callback x request
              | Error err -> failure_callback err request)
        in
        (reduce_middlewares full_handler middlewares) request
      | None -> aux services)
    | Failable_with_attachment
        { endpoint
        ; handler
        ; middlewares
        ; succeed_callback
        ; failure_callback
        ; attached
        }
      :: services ->
      (match Endpoint.handle endpoint method_ uri Fun.id handler with
      | Some callback ->
        let inner_handler attachment request =
          Lwt.bind (callback attachment request) (function
              | Ok x -> succeed_callback x request
              | Error err -> failure_callback err request)
        in
        let full_handler request = attached inner_handler request in
        (reduce_middlewares full_handler middlewares) request
      | None -> aux services)
  in
  aux services
;;
