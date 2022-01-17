(** Help for handling complex printers. *)

(** {1 Types} *)

(** An alias for [Format.formatter -> 'a -> unit]. *)
type 'a t = Format.formatter -> 'a -> unit

(** A packed formatter. *)
type packed

(** {1 API} *)

(** Pack a value with a formatter. *)
val pack : 'a -> 'a t -> packed

(** Print unit. *)
val unit : unit t

(** Print string. *)
val string : string t

(** Print int. *)
val int : int t

(** Print something with double quotes.*)
val double_quoted : 'a t -> 'a t

(** Print a list using [;] as a separator.*)
val list : 'a t -> 'a list t

(** Print something with simple quotes.*)
val simple_quoted : 'a t -> 'a t

(** {2 Print records} *)

(** Group a field with a label. *)
val field : string -> 'a -> 'a t -> string * packed

(** Print a record field by fields. *)
val record : (string * packed) list t

(** {2 Print sums fragment} *)

(** Print a simple constructor without argument. *)
val branch : string t

(** Print a simple constructor with arguments. *)
val branch_with : 'a t -> 'a -> string t
