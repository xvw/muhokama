let make_uri ~user ~password ~host ~port ~database =
  Format.asprintf "postgresql://%s:%s@%s:%d/%s" user password host port database
  |> Uri.of_string
;;

let connect ~max_size ~user ~password ~host ~port ~database =
  let uri = make_uri ~user ~password ~host ~port ~database in
  (match Caqti_lwt.connect_pool ~max_size uri with
  | Ok pool -> Preface.Try.ok pool
  | Error e ->
    let message = Caqti_error.show e in
    Preface.Try.error @@ Exn.Database message)
  |> Lwt.return
;;

let as_try caqti_obj =
  let open Lwt in
  caqti_obj
  >>= function
  | Ok result -> return @@ Preface.Try.ok result
  | Error err ->
    let message = Caqti_error.show err in
    return Exn.(as_try @@ Database message)
;;

let use pool callback = as_try (Caqti_lwt.Pool.use callback pool)
