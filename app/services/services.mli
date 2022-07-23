(** Since some files can share the name (but not the same path) so to simplify
    the navigation between files and facilitate their identification, they are
    suffixed by model. This module is used to re-export them. *)

module Global = Global_services
module User = User_services
module Topic = Topic_services
module Admin = Admin_services
module Category = Category_services
