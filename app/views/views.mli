(** Since some files can share the name (but not the same path) so to simplify
    the navigation between files and facilitate their identification, they are
    suffixed by view. This module is used to re-export them. *)

module Global = Global_views
module User = User_views
module Topic = Topic_views
module Admin = Admin_views
module Category = Category_views
module Shared_link = Shared_link_views
