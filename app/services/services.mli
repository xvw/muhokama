(** Since some files can share the name (but not the same path) so to simplify
    the navigation between files and facilitate their identification, they are
    suffixed by model. This module is used to re-export them. *)

module Dummy = Dummy_services
module User = User_services
module Admin = Admin_services
