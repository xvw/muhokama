(** Since some file (in model, view and controller) can share the name (but not
    the same path) so to simplify the navigation between files and facilitate
    their identification, they are suffixed by model. This module is used to
    re-export them. *)

module Dummy = Dummy_controller
module User = User_controller
