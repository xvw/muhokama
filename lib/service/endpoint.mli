(** Define a HTTP endpoint. *)

(** {1 HTTP method Types} *)

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

(** {1 Endpoint types} *)

(** Define an endpoint based on a [Path.t]. The last two parameters are used to
    abstract the use of Dream.*)
type ('method_, 'continuation, 'normal_form, 'request, 'response) t

(** {1 Building endpoint} *)

(** [get (fun () -> path) \[middlewares\] ()] builds a GET endpoint to which a
    list of [middlewares] will be applied.*)
val get
  :  (unit -> ('continuation, 'normal_form) Path.t)
  -> (('request -> 'response) -> 'request -> 'response) list
  -> unit
  -> ([ `GET ], 'continuation, 'normal_form, 'request, 'response) t

(** [post (fun () -> path) \[middlewares\] ()] builds a POST endpoint to which a
    list of [middlewares] will be applied.*)
val post
  :  (unit -> ('continuation, 'normal_form) Path.t)
  -> (('request -> 'response) -> 'request -> 'response) list
  -> unit
  -> ([ `POST ], 'continuation, 'normal_form, 'request, 'response) t

(** {1 Routing}

    A router is a function for deciding which endpoint to choose from a list
    based on an HTTP method. *)

(** A packed version of an endpoint. *)
type ('normal_form, 'request, 'response) route

(** Pack an endpoint into a route.*)
val route
  :  ('method_, 'continuation, 'normal_form, 'request, 'response) t
  -> 'continuation
  -> ('normal_form, 'request, 'response) route

(** [decide routes method_ next_handler request] captures the endpoint that
    corresponds to the method and the string passed as argument. If no route is
    candidate, [next_handler] is executed (by applying [request] to it).*)
val decide
  :  ('request -> 'response, 'request, 'response) route list
  -> method_
  -> string
  -> ('request -> 'response)
  -> 'request
  -> 'response

(** {1 Extracting data about endpoint} *)

(** [href endpoint] gives its URL. This is only allowed for GET endpoints
    because a POST service is not accessible from a hyperlink.*)
val href
  :  ([ `GET ], 'continuation, string, 'request, 'response) t
  -> 'continuation

(** [method_ endpoint] gives the form method (according to TyXML specs). *)
val method_
  :  ('method_, 'continuation, 'normal_form, 'request, 'response) t
  -> [> `Get | `Post ]

(** [action endpoint] gives its URL. This is only allowed for all endpoints
    since GET and POST can be feed through form query..*)
val action
  :  ('method_, 'continuation, string, 'request, 'response) t
  -> 'continuation
