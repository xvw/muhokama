open Lib_service.Endpoint

let list () = get (~/"category" / "list")