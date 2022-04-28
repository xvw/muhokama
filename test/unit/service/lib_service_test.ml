let suites = [ Helper_test.cases; Path_test.cases; Endpoint_test.cases ]
let () = Alcotest.run "Lib_service" suites
