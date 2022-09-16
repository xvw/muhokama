let suites = [ Validate_test.cases; Assoc_test.cases; Html_test.cases ]
let () = Alcotest.run "Lib_common" suites
