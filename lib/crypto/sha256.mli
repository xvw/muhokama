type t

val hash_bytes : Bytes.t -> t
val hash_string : string -> t
val hash_list : ('a -> t) -> 'a list -> t
val hash_option : ('a -> t) -> 'a option -> t
val to_string : t -> string
val to_bytes : t -> Bytes.t
val equal : t -> t -> bool
val pp : Format.formatter -> t -> unit

include Preface.Specs.MONOID with type t := t
