(** Since some file (in model, view and controller) can share the name (but not
    the same path) so to simplify the navigation between files and facilitate
    their identification, they are suffixed by view. This module is used to
    re-export them. *)

module Dummy = Dummy_view
module User = User_view
