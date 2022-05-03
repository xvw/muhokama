open Lib_service.Endpoint

let user () = get (~/"admin" / "user")
let user_change_state () = post (~/"user" / "state")
