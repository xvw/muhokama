open Lib_service.Endpoint

let root () = get ~/"topics"
let create () = get (~/"topic" / "new")
let save () = post (~/"topic" / "new")
let show () = get (~/"topic" / "show" /: string)
let by_category () = get (~/"topic" / "by" / "category" /: string)
let answer () = post (~/"topic" /: string / "answer")
