let suites = [ Endpoint_test.cases; Helper_test.cases; Service_test.cases ]
let () = Alcotest.run "Service" suites
