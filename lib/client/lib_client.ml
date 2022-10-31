open Cohttp
open Cohttp_lwt_unix

let post ?(headers = []) ?(data = "") url =
  let uri = Uri.of_string url in
  let headers = Header.of_list headers in
  let body = Cohttp_lwt.Body.of_string data in
  Client.post ~headers ~body uri
;;

let post_json ?(headers = []) ~data url =
  let headers = ("Content-Type", "application/json") :: headers in
  post ~headers ~data url
;;
