(** A [Service.t] associates an [Endpoint.t] with a Handler (a function whose
    parameters are defined by the endpoint given as argument). A service can be
    seen as a controller. The separation of the definition of endpoints and
    services makes it possible to use endpoints directly in services to
    generate, for example, the links between different services. *)

(** {1 Types} *)

(** A service taking a request as an argument and returning a response (the
    response must be wrapped in a promise [Lwt]) *)
type ('request, 'response) t

(** A [handler] is the "normal" form of a service. It takes a request and
    returns a response wrapped in a [Lwt] promise. For example, a service
    expecting an integer and a string (via the [Endpoint.t] definition) will
    take a handler function of this form:
    [int -> string -> ('request, 'response) handler]. *)
type ('request, 'response) handler = 'request -> 'response Lwt.t

(** [middleware] allows the request to be modified or another response to be
    returned before the service is executed. *)
type ('request, 'response) middleware =
  ('request, 'response) handler -> ('request, 'response) handler

(** Just an alias for a [list of middlewares]. *)
type ('request, 'response) middlewares = ('request, 'response) middleware list

(** {1 Defining services}

    A service associates an [endpoint.t] with a specific behaviour (a callback
    function whose arguments are defined by the type of the [endpoint]). *)

(** {2 Straight services}

    "Straight" services define the simplest form of service. They return
    responses directly (after applying the middleware list). For example, here
    is a very simple service that just say hello world.

    {[
      let hello_world_service =
        Service.straight
          Endpoint.(get (~/"hello" / "world"))
          []
          (fun _request ->
            let result = "Hello, World!" in
            Lwt.return result)
      ;;
    ]}

    As our endpoint does not declare any variables, the management function only
    takes the request as an argument. Here is an example that uses variables
    (and and does very complicated arithmetic):

    {[
      let sum_service =
        Service.straight
          Endpoint.(get (~/"sum" /: int /: int))
          []
          (fun x y _request ->
            let result = Format.asprintf "%d + %d = %d" x y (x + y) in
            Lwt.return result)
      ;;
    ]}

    It is the type of the [endpoint] that defines the type of the handling
    function. *)

(** [straight endpoint middlewares handler_function] declares a "straight"
    service. *)
val straight
  :  ('method_, 'handler_function, ('request, 'response) handler) Endpoint.t
  -> ('request, 'response) middlewares
  -> 'handler_function
  -> ('request, 'response) t

(** Sometimes you may want to provision a service with data, for example suppose
    you have a middleware that checks if a user is logged in
    ([is_authenticated]) and a function that gets the logged in user
    ([get_current_user]). We would like to force {b at the service level} the
    retrieval of the user rather than having to process it each time in the
    handling function (for all services requiring the connection).

    Straight services can have an attachment that will vary the type of
    management function to provision a data service. For example:

    {[
      let provide_user handler request =
        match get_current_user () with
        (* Not logged, redirect to login page *)
        | None -> redirect_to request login_endpoint
        (* Logged, ensure that the user is activated *)
        | Some user ->
          if User.is_activate user
          then handler user request
          else redirect_to request login_endpoint
      ;;
    ]}

    Now we can write a service that gives access to a secret area if the user is
    connected and if the password, passed in clear in the URL (we are cowboys!)
    displays the secret message, otherwise sends back to the home page.!

    {[
      let secret_area_service =
        Service.straight_with
          Endpoint.(get (~/"secret" / "area" /: string))
          [ is_authenticated ]
          ~attached:provide_user
          (fun password user request ->
            if password = "qwerty"
            then
              Lwt.return
              @@ Format.asprintf "Welcome %s to the secret area!" user.name
            else redirect_to request home)
      ;;
    ]}

    The purpose of the attached provisioner is to provide another kind of
    mutualisable [middleware] that provides the management function. This is
    useful in particular for generalising the provisioning of, for example, the
    current logged-in user. *)

(** [straight_with endpoint middlewares ~attached handler_function] declares a
    "straight" service with attached provisioner. *)
val straight_with
  :  attached:
       (('attachment -> ('request, 'response) handler)
        -> ('request, 'response) handler)
  -> ( 'method_
     , 'handler_function
     , 'attachment -> ('request, 'response) handler )
     Endpoint.t
  -> ('request, 'response) middlewares
  -> 'handler_function
  -> ('request, 'response) t

(** {2 Failable services}

    Web programming is, among other things, about data validation, if the data
    is not good (and cannot be statically validated) a service sometimes fails.
    As opposed to "straight" services, "failable" services make it possible to
    manage this disjunction at the level of their definition. Let's improve our
    [sum] service to allow it to handle more complex operations! This time, we
    are going to parameterise it, in addition to two numbers, with a character
    that will define the arithmetic operation to be performed. If the operator
    is not recognised, the service will fail.

    {[
      let calculator_service =
        Service.failable
          Endpoint.(get (~/"calculator" /: char /: int /: int))
          []
          (fun operator x y _request ->
            let operator_f =
              match operator with
              | '+' -> Ok ( + )
              | '-' -> Ok ( - )
              | '*' -> Ok ( * )
              | '/' -> Ok ( / )
              | chr -> Error "unknown operator"
            in
            Lwt.return (Result.map (fun f -> f, operator, x, y) operator_f))
          ~succeed:(fun (f, c, x, y) _request ->
            let result = Format.asprintf "%d %c %d = %d" x c y (f x y) in
            Lwt.return result)
          ~failure:(fun _error _request ->
            Lwt.return "Unable to make the computation :(")
      ;;
    ]}

    This allows us to have a clear separation between the state that the service
    calculates, then we simply provide a visitor to view the result. *)

(** [failable endpoint middlewares handler_function ~succeed ~error] declares a
    "failable" service. *)
val failable
  :  ( 'method_
     , 'handler_function
     , ('request, ('result, 'error) result) handler )
     Endpoint.t
  -> ('request, 'response) middlewares
  -> succeed:('result -> ('request, 'response) handler)
  -> failure:('error -> ('request, 'response) handler)
  -> 'handler_function
  -> ('request, 'response) t

(** As with "straight" services, it is possible to attach a provisioner to a
    "failable" service. Let's enhance our previous example to manage the
    password using an attached failable service.

    {[
      let secret_area_service =
        Service.failable_with
          Endpoint.(get (~/"secret" / "area" /: string))
          [ is_authenticated ]
          ~attached:provide_user
          (fun password user _request ->
            if password = "qwerty"
            then Lwt.return (Ok user)
            else Lwt.return (Error "invalid password"))
          ~succeed:(fun user _request ->
            Format.asprintf "Welcome %s to the secret area!" user.name
            |> Lwt.return)
          ~failure:(fun err _request -> Lwt.return err)
      ;;
    ]}

    As before, the separation between the construction of a state (which can be
    provisioned) is clear. In general, the [_with] suffixed versions of service
    statements allow for the addition of middleware that computes more than just
    requests and responses. *)

(** [failable_with endpoint middlewares ~attached handler_function ~succeed ~error]
    declares a "failable" service with attached provisioner.*)
val failable_with
  :  attached:
       (('attachment -> ('request, 'response) handler)
        -> ('request, 'response) handler)
  -> ( 'method_
     , 'handler_function
     , 'attachment -> ('request, ('result, 'error) result) handler )
     Endpoint.t
  -> ('request, 'response) middlewares
  -> succeed:('result -> ('request, 'response) handler)
  -> failure:('error -> ('request, 'response) handler)
  -> 'handler_function
  -> ('request, 'response) t

(** {1 Routing services}

    As services existentially pack heterogeneous types, it is possible to
    "route" a service present in a list of services. The role of the [choose]
    function is to simulate a router. *)

(** [choose method_ request_uri services fallback request] Will try to find a
    candidate service in the list [services] granted with the [method_] and
    [request_uri] given as argument. If no service is valid, [fallback] will be
    executed. *)
val choose
  :  Endpoint.method_
  -> string
  -> ('request, 'response) t list
  -> ('request, 'response) handler
  -> ('request, 'response) handler
