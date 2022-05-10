open Lib_service.Endpoint

let root () = get ~/"admin"
let user () = get (~/"admin" / "user")
let user_state_change () = post (~/"admin" / "user" / "state")
let category () = get (~/"admin" / "category")
let new_category () = post (~/"admin" / "category" / "new")
