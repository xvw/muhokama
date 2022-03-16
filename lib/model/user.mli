open Lib_common
open Lib_crypto

val count : Caqti_lwt.connection -> int Try.t Lwt.t

module State : sig
  type t =
    | Inactive
    | Member
    | Moderator
    | Admin
    | Unknown of string

  val equal : t -> t -> bool
  val pp : t Fmt.t
  val to_string : t -> string
  val validate_state : string -> t Validate.t
  val try_state : string -> t Try.t
  val from_string : string -> t
  val compare : t -> t -> int
end

module Pre_saved : sig
  type t = private
    { user_name : string
    ; user_email : string
    ; user_password : Sha256.t
    }

  val formlet : Formlet.t4
  val create : Assoc.Yojson.t -> t Try.t
  val from_urlencoded : (string * string list) list -> t Try.t
  val from_assoc_list : (string * string) list -> t Try.t
  val save : Caqti_lwt.connection -> t -> unit Try.t Lwt.t
end

module Saved : sig
  type t = private
    { user_id : string
    ; user_name : string
    ; user_email : string
    ; user_state : State.t
    }

  val iter : Caqti_lwt.connection -> (t -> unit) -> unit Try.t Lwt.t

  val change_state
    :  Caqti_lwt.connection
    -> string
    -> State.t
    -> unit Try.t Lwt.t

  val activate : Caqti_lwt.connection -> string -> unit Try.t Lwt.t
end
