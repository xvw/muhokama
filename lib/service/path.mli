(** [Path] provides a path-typed approach for [Routes].

    The module allows to define paths attached to continuations (in the
    type-level) to define, for example, automatically a router or to build urls
    in a type-safe way. *)

(** {1 Types} *)

type ('continuation, 'usage) t
type 'caml_type witness

(** {1 Rendering a path} *)

val to_route : (_, _) t -> string
val to_string : ('a, string) t -> 'a
val handle : (string -> string) -> ('a, 'b) t -> 'a -> 'b
val handle_with : string -> ('a, 'b) t -> 'a -> 'b option

(** {1 Building a path} *)

val root : ('a, 'a) t
val ( ! ) : string -> ('a, 'a) t
val ( !: ) : 'a witness -> ('a -> 'b, 'b) t
val ( / ) : ('a, 'b) t -> string -> ('a, 'b) t
val ( /: ) : ('a, 'b -> 'c) t -> 'b witness -> ('a, 'c) t

(** {1 Typed variables} *)

val string : string witness
val int : int witness
val bool : bool witness
val float : float witness
val char : char witness
