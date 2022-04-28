(** Since some file (in model, view, controller and service) can share the name
    (but not the same path) so to simplify the navigation between files and
    facilitate their identification, they are suffixed by service. This module
    is used to re-export them. *)

(** {1 Endpoints} *)

module Global = Global
module User = User_service

(** {1 Middlewares} *)

module Middleware = Middleware

(** {1 Helpers} *)

module Auth = Auth
module Flash_info = Flash_info
