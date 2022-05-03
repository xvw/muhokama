open Lib_service.Endpoint

let create () = get (~/"user" / "new")
let login () = get (~/"user" / "login")
let register () = post (~/"user" / "new")
let auth () = post (~/"user" / "auth")
let leave () = get (~/"user" / "leave")
let list () = get (~/"user" / "list")
