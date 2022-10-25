open Lib_service.Endpoint

let root () = get ~/"links"
let create () = post ~/"links"
