(** [Lib_service] allows you to declare controllers in two parts:

    First, by defining endpoints that correspond to the association between an
    HTTP method and a path. These paths may require variables that must be
    supplied to the handlers.

    Then you have to describe a service that associates an endpoint with a
    handler (which corresponds to a controller in MVC terminology). There are
    several types of services (which can, for example, fail or not), *)

(**/**)

module Helper = Helper

(**/**)

(** Describes the association between a Method and a Path. *)
module Endpoint = Endpoint

(** Links an endpoint to a handler. *)
module Service = Service

(** {1 Utils} *)

(** [~:f] is equivalent to [f ()]. *)
val ( ~: ) : (unit -> 'a) -> 'a
