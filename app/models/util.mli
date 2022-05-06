(** Some useful function related to each models. *)

(** [normalize_name str] will trim and lowercase a string. *)
val normalize_name : string -> string

(** [hash_password ~email ~password] will produce a password (that rely on the
    password and the email to avoid revealing identical passwords)*)
val hash_password : email:string -> password:string -> Lib_crypto.Sha256.t
