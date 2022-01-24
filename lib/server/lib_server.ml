open Lib_common

let run ~port env =
  let open Lwt_util in
  let app =
    Lwt.return_ok Opium.App.empty
    >>=? Middleware.static_css
    >>=? Middleware.static_images
    >>=? Middleware.database env
    >>=? Router.routes
    >|=? Opium.App.port port
  in
  Lwt.async (fun () ->
      let promise =
        let*? app in
        let*? _server = Opium.App.start app >|= Try.ok in
        Lwt.return_ok ()
      in
      promise
      >>= function
      | _ -> Lwt.return_unit);
  let forever, _ = Lwt.wait () in
  let+ wrapped_value = forever in
  wrapped_value
;;
