let suites =
  [ Global_test.cases
  ; User_test.cases
  ; Category_test.cases
  ; Topic_test.cases
  ; Message_test.cases
  ]
;;

let () = Alcotest.run "Integration test" suites
