(** A [Service.t] associates an [Endpoint.t] with a Handler (a function whose
    parameters are defined by the endpoint given as argument). A service can be
    seen as a controller. *)

(** {1 Types} *)

(** Description of a service indexed by a request and a response. *)
type ('request, 'response) t

(** {1 Defining services} *)

(** [make ~middlewares endpoint finalizer handler] will sequentially apply all
    middleware, then the handler and send the result of the handler to the
    finalizer. This function is essentially internal and is used to describe
    more complex services. *)
val make
  :  ?middlewares:(('request -> 'response) -> 'request -> 'response) list
  -> ('method_, 'handler_function, 'request -> 'result) Endpoint.t
  -> ('result -> 'request -> 'response)
  -> 'handler_function
  -> ('request, 'response) t

(** [regular ~middlewares endpoint handler] produces a service whose handler
    returns the response (which must be a promise [Lwt]. When used with Dream,
    it is common to return [Dream.response]. *)
val regular
  :  ?middlewares:
       (('request -> 'response Lwt.t) -> 'request -> 'response Lwt.t) list
  -> ('method_, 'handler_function, 'request -> 'response Lwt.t) Endpoint.t
  -> 'handler_function
  -> ('request, 'response Lwt.t) t

(** [failable ~middlewares endpoint handler] It is quite common to have services
    that can fail (and for example redirect to an error page), [failable]
    describes a service whose handler can fail and provides two completion
    functions, one on success and one on error. *)
val failable
  :  ?middlewares:
       (('request -> 'response Lwt.t) -> 'request -> 'response Lwt.t) list
  -> ( 'method_
     , 'handler_function
     , 'request -> ('result, 'error) result Lwt.t )
     Endpoint.t
  -> ok:('result -> 'request -> 'response Lwt.t)
  -> error:('error -> 'request -> 'response Lwt.t)
  -> 'handler_function
  -> ('request, 'response Lwt.t) t

(** {1 Routing services} *)

(** [chose method_ uri services fallback request] will choose in [services] the
    service to handle. If no service is a potential candidate, [fallback] will
    be executed.*)
val choose
  :  Endpoint.method_
  -> string
  -> ('request, 'response) t list
  -> ('request -> 'response)
  -> 'request
  -> 'response
