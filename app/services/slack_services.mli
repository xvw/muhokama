open Lib_common

(** Some hooks for making notification in Slack. *)

(** [new_topic user topic_id topic_title] raise a notification when a topic has
    been created. *)
val new_topic : Models.User.t -> string -> string -> Env.t -> unit Try.t Lwt.t

(** [new_answer user topic_id topic message_id] raise a notification when an
    answer has been posted. *)
val new_answer
  :  Models.User.t
  -> string
  -> Models.Topic.Showable.t
  -> string
  -> Env.t
  -> unit Try.t Lwt.t
