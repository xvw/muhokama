(** Some helpers to deal with HTML. *)

(** Escape html special chars from a string. The table of special chars come
    from: https://www.php.net/manual/fr/function.htmlspecialchars.php *)
val escape_special_chars : string -> string
