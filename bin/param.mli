open Lib_common

val migrations_path_default : Io.dirpath
val migrations_path_term : string Cmdliner.Term.t
val migrate_to_term : int option Cmdliner.Term.t
