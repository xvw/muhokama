(** A small HTTP client for comunicating with Webhook. *)

val post
  :  ?headers:(string * string) list
  -> ?data:string
  -> string
  -> (Cohttp.Response.t * Cohttp_lwt.Body.t) Lwt.t

val post_json
  :  ?headers:(string * string) list
  -> data:string
  -> string
  -> (Cohttp.Response.t * Cohttp_lwt.Body.t) Lwt.t
