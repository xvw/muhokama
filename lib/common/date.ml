module Int_map = Map.Make (Int)

let db =
  let seq =
    [ 2020, ((29, 3), (25, 10))
    ; 2021, ((28, 3), (31, 10))
    ; 2022, ((27, 3), (30, 10))
    ; 2023, ((26, 3), (29, 10))
    ; 2024, ((31, 3), (27, 10))
    ; 2025, ((30, 3), (26, 10))
    ]
    |> List.to_seq
  in
  Int_map.of_seq seq
;;

let offset date =
  let result =
    let open Preface.Option.Monad in
    let year, _, _ = Ptime.to_date date in
    let* (s_day, s_month), (w_day, w_month) = Int_map.find_opt year db in
    let* s_date = Ptime.of_date_time ((year, s_month, s_day), ((3, 0, 0), 0)) in
    let+ w_date = Ptime.of_date_time ((year, w_month, w_day), ((3, 0, 0), 0)) in
    if Ptime.is_later ~than:s_date date && Ptime.is_earlier ~than:w_date date
    then 2
    else 1
  in Option.value ~default:1 result
;;
