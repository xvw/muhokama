let migrations_path_default = "./migrations"
let docs = Cmdliner.Manpage.s_common_options

let migrations_path_term =
  let open Cmdliner in
  let doc =
    Format.asprintf
      "Defines the path where the migrations to be executed are located \
       (default value: %s)"
      migrations_path_default
  in
  let arg = Arg.info ~doc ~docs [ "migrations-path"; "mpath" ] in
  Arg.(value (opt file migrations_path_default arg))
;;
