open Lib_service.Endpoint

let root () = get ~/"topic"
let create () = get (~/"topic" / "new")
let save () = post (~/"topic" / "new")
let show () = get (~/"topic" / "show" /: string)
