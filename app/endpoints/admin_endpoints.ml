open Lib_service.Endpoint

let root () = get ~/"admin"
let user () = get (~/"admin" / "user")
let user_state_change () = post (~/"user" / "state")
