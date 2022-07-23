(** Since some files can share the name (but not the same path) so to simplify
    the navigation between files and facilitate their identification, they are
    suffixed by model. This module is used to re-export them. *)

module Global = Global_endpoints
module User = User_endpoints
module Topic = Topic_endpoints
module Admin = Admin_endpoints
module Category = Category_endpoints
