open Lib_common
open Lib_db
open Lib_crypto

val count : Caqti_error.t connection -> int Try.t Lwt.t

module Pre_saved : sig
  type t = private
    { user_name : string
    ; user_email : string
    ; user_password : Sha256.t
    }

  val formlet : Formlet.t4
  val create : Assoc.Yojson.t -> t Try.t
  val from_urlencoded : (string * string list) list -> t Try.t
  val save : Caqti_error.t connection -> t -> unit Try.t Lwt.t
end
