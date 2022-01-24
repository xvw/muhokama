let migrations_path_default = "./migrations"
let launching_port_default = 4000
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

let migrate_to_term =
  let open Cmdliner in
  let doc =
    "Specifies the migration number where the migration programme should go"
  in
  let arg = Arg.info ~doc ~docs [ "migrate-to"; "to" ] in
  Arg.(value & opt (some int) None & arg)
;;

let launching_port_term =
  let open Cmdliner in
  let doc =
    Format.asprintf
      "Defines the port on which the server should listen (default value: %d)"
      launching_port_default
  in
  let arg = Arg.info ~doc ~docs [ "port"; "P" ] in
  Arg.(value (opt int launching_port_default arg))
;;
