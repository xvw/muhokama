open Tyxml

val preconnect : ?crossorigin:bool -> string -> [> Html_types.link ] Html.elt
val stylesheet : string -> [> Html_types.link ] Html.elt
