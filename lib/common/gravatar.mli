(** Generate Gravatar URL.*)

(** Default style of the avatar.*)
type default_style =
  | Mp
  | Identicon
  | MonsterId
  | Wavatar
  | Retro
  | Robohash
  | Blank
  | Error404

(** Generate an Avatar URL. *)
val url : ?default:default_style -> ?size:int -> string -> string
