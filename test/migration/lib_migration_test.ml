let suites = [ Migration_test.cases; Context_test.cases ]
let () = Alcotest.run "Lib_migration" suites
