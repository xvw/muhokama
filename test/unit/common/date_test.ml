open Lib_test

let test_offset_date =
  test
    ~about:"test_winter_date"
    ~desc:
      "Test that for winter date the time zone it UTC+1 and that for summer \
       date the time zone is UTC+2"
    (fun () ->
    [ ((2024, 02, 06), (16, 32, 15)), 1
    ; ((2020, 01, 09), (02, 43, 33)), 1
    ; ((2020, 05, 08), (02, 45, 03)), 2
    ; ((2020, 11, 29), (04, 13, 30)), 1
    ; ((2021, 01, 11), (05, 18, 17)), 1
    ; ((2021, 11, 26), (05, 52, 13)), 1
    ; ((2022, 03, 18), (06, 40, 02)), 1
    ; ((2022, 09, 03), (08, 55, 01)), 2
    ; ((2024, 06, 11), (11, 13, 52)), 2
    ; ((2024, 11, 04), (11, 47, 59)), 1
    ; ((2024, 11, 11), (12, 55, 59)), 1
    ; ((2024, 12, 20), (13, 00, 26)), 1
    ; ((2025, 08, 06), (14, 47, 27)), 2
    ; ((2025, 08, 18), (22, 16, 14)), 2
    ; ((2025, 08, 29), (23, 13, 34)), 2
    ; ((2025, 08, 31), (23, 39, 47)), 2
    ]
    |> List.iter (fun ((date, time), expeted_tz) ->
         let computed =
           Ptime.of_date_time (date, (time, 0))
           |> Option.map Lib_common.Date.offset
         and expected = Some expeted_tz in
         Alcotest.(check (option int))
           "Are all the timezone correct"
           computed
           expected))
;;

let cases = "Date validation", [ test_offset_date ]
