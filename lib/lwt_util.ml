let return = Lwt.return
let pure = return
let return_ok x = return (Ok x)
let map = Lwt.map
let bind f x = Lwt.bind x f
let ( >|= ) x f = map f x
let ( >>= ) = Lwt.bind
let ( let+ ) x f = map f x
let ( let* ) = Lwt.bind

let ( >|=? ) promise f =
  let* result = promise in
  match result with
  | Ok x -> return_ok (f x)
  | Error e -> return @@ Error e
;;

let map_ok f x = x >|=? f

let ( >>=? ) promise f =
  let* result = promise in
  match result with
  | Ok x -> f x
  | Error e -> return @@ Error e
;;

let bind_ok f x = x >>=? f
let ( let*? ) = ( >>=? )
let ( let+? ) = ( >|=? )
