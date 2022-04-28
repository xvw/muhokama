(** A middleware that redirects to a service if a user is logged in on a page
    where they should not be. (For example, if a logged-in user tries to
    register). *)
val not_authenticated
  :  ([ `GET ], string, string, _, _) Lib_service.Endpoint.t
  -> Dream.middleware

(** A middleware that redirects to a service if a user is not logged in on a
    page where they should be. *)
val authenticated
  :  ([ `GET ], string, string, _, _) Lib_service.Endpoint.t
  -> Dream.middleware
