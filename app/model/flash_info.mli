(** [Flash_info.t] (or main notification) displayed after an action (or to give
    some context after a redirection). For example when an user was successfuly
    (or not) logged in the application.

    This is an internal representation and we do not care about the
    serialization strategy. At the moment, Json is used for conveinence issue. *)

type t =
  | Action of string (** For relaying a successful performed action *)
  | Info of string (** For adding more context after a redirection *)
  | Alert of string
      (** For displaying an inlined error with a specific message *)
  | Error_tree of Lib_common.Error.error_tree
      (** For representing an error tree (using [Error.normalize])*)
  | Nothing (** The neutral element of the flash_info *)

(** [serialize flash_info] will convert a flash info into a string (to be stored
    in the request) *)
val serialize : t -> string

(** [unserialize flash_info] will reconvert a serialized flash info into a
    concrete representation. *)
val unserialize : string -> t
