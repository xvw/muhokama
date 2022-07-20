open Lib_service

(** Provide a page which list all available categories for users *)
val topics_count_by_categories : (Dream.request, Dream.response) Service.t
