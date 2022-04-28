type method_ = Endpoint.method_

module Helper = Helper
module Path = Path
module Endpoint = Endpoint

let ( ~: ) f = f ()
let ( >> ) = Endpoint.route
