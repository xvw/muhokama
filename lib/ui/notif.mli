type t =
  | Action of string
  | Info of string
  | Alert of string
  | Error_tree of Lib_common.Error.error_tree
  | Nothing
