open Lib_test
open Lib_common
open Lib_crypto
open Lib_migration
open Alcotest

let dirs =
  [ "empty", []
  ; "dir-1", [ "1-test.yml" ]
  ; "dir-2", [ "1-test.yml"; "2-test-2.yml" ]
  ; ( "dir-3"
    , [ "1-test.yml"; "2-test.yml"; "3-test.yml"; "3-another-test-3.yml" ] )
  ; ( "dir-4"
    , [ "1-test.yml"
      ; "2-test.yml"
      ; "0000-should-produce-a-warning"
      ; "3-test.yml"
      ; "5-omg-where-is-the-fourth-migration.yml"
      ] )
  ; ( "dir-5"
    , [ "1-test.yml"
      ; "2-test.yml"
      ; "3-test.yml"
      ; "4-sadlsad.yml"
      ; "5-sadlsad.yml"
      ; "6-sadlsad.yml"
      ; "7-sadlsad.yml"
      ; "8-sadlsad.yml"
      ; "9-sadlsad.yml"
      ; "10-sadlsad.yml"
      ; "11-sadlsad.yml"
      ] )
  ]
;;

let files =
  [ "dir-1/1-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; ( "dir-2/1-test.yml"
    , Ok (`O [ "up", `A [ `String "foo" ]; "down", `A [ `String "bar" ] ]) )
  ; "dir-2/2-test-2.yml", Ok (`O [ "down", `A [ `String "bar" ] ])
  ; "dir-3/1-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-3/2-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-3/3-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-3/3-another-test-3.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-4/1-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-4/2-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-4/3-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; ( "dir-4/5-omg-where-is-the-fourth-migration.yml"
    , Ok (`O [ "up", `A []; "down", `A [] ]) )
  ; "dir-5/1-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/2-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/3-test.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/4-sadlsad.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/5-sadlsad.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/6-sadlsad.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/7-sadlsad.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/8-sadlsad.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/9-sadlsad.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/10-sadlsad.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ; "dir-5/11-sadlsad.yml", Ok (`O [ "up", `A []; "down", `A [] ])
  ]
;;

let read_dir dir =
  match List.assoc_opt dir dirs with
  | None -> Error.(to_try @@ io_unreadable_dir ~dirpath:dir)
  | Some x -> Try.ok x
;;

let read_file file =
  match List.assoc_opt file files with
  | None -> Error.(to_try @@ io_unreadable_file ~filepath:file)
  | Some x -> x
;;

let handle buff program =
  let handler : type a. (a -> 'b) -> a Effect.f -> 'b =
   fun resume -> function
    | Fetch_migrations migrations_path -> resume @@ read_dir migrations_path
    | Read_migration filepath -> resume @@ read_file filepath
    | Info message ->
      let () = buff := !buff @ [ "info", message ] in
      resume ()
    | Warning message ->
      let () = buff := !buff @ [ "warning", message ] in
      resume ()
    | Error err -> Try.error err
  in
  Effect.run { handler } program
;;

let handle_init buff migrations_path =
  handle buff @@ Context.init migrations_path
;;

let migration_list_testable = Testable.try_ (list (pair int Testable.migration))

let test_init_on_empty_folder =
  test
    ~about:"init"
    ~desc:"When there is no migration it should produce an empty context"
    (fun () ->
      let buff = ref [] in
      let expected = Ok []
      and computed = handle_init buff "empty" |> Try.map Context.to_list in
      same
        (list (pair string string))
        ~expected:[ "info", "Reading migration into empty" ]
        ~computed:!buff;
      same migration_list_testable ~expected ~computed)
;;

let test_init_on_inexistant_folder =
  test
    ~about:"init"
    ~desc:"When there is no folder it should produce an error"
    (fun () ->
      let buff = ref [] in
      let expected =
        Error.(to_try @@ io_unreadable_dir ~dirpath:"non-existing-folder")
      and computed =
        handle_init buff "non-existing-folder" |> Try.map Context.to_list
      in
      same
        (list (pair string string))
        ~expected:[ "info", "Reading migration into non-existing-folder" ]
        ~computed:!buff;
      same migration_list_testable ~expected ~computed)
;;

let test_init_on_dir_1_folder =
  test
    ~about:"init"
    ~desc:"When there is one migration it should produce a filled context"
    (fun () ->
      let buff = ref [] in
      let expected =
        Ok [ 1, Migration.make 1 "test" "1-test.yml" [] [] Sha256.neutral ]
      and computed = handle_init buff "dir-1" |> Try.map Context.to_list in
      same
        (list (pair string string))
        ~expected:
          [ "info", "Reading migration into dir-1"
          ; "info", "Storing file: 1-test.yml in context"
          ]
        ~computed:!buff;
      same migration_list_testable ~expected ~computed)
;;

let test_init_on_dir_2_folder =
  test
    ~about:"init"
    ~desc:"When there is invalid  migration it should produce an error"
    (fun () ->
      let buff = ref [] in
      let expected =
        Error
          Error.(
            Invalid_object
              { name = "2-test-2.yml"
              ; errors = nel (Field (Missing { name = "up" })) []
              })
      and computed = handle_init buff "dir-2" |> Try.map Context.to_list in
      same
        (list (pair string string))
        ~expected:
          [ "info", "Reading migration into dir-2"
          ; "info", "Storing file: 1-test.yml in context"
          ]
        ~computed:!buff;
      same migration_list_testable ~expected ~computed)
;;

let test_init_on_dir_3_folder =
  test
    ~about:"init"
    ~desc:"When there is multiple index it should produce an error"
    (fun () ->
      let buff = ref [] in
      let expected =
        Error
          Error.(migration_invalid_successor ~expected_index:4 ~given_index:3)
      and computed = handle_init buff "dir-3" |> Try.map Context.to_list in
      same
        (list (pair string string))
        ~expected:
          [ "info", "Reading migration into dir-3"
          ; "info", "Storing file: 1-test.yml in context"
          ; "info", "Storing file: 2-test.yml in context"
          ; "info", "Storing file: 3-test.yml in context"
          ]
        ~computed:!buff;
      same migration_list_testable ~expected ~computed)
;;

let test_init_on_dir_4_folder =
  test
    ~about:"init"
    ~desc:"When there is missing index it should produce an error"
    (fun () ->
      let buff = ref [] in
      let expected =
        Error
          Error.(migration_invalid_successor ~expected_index:4 ~given_index:5)
      and computed = handle_init buff "dir-4" |> Try.map Context.to_list in
      same
        (list (pair string string))
        ~expected:
          [ "info", "Reading migration into dir-4"
          ; ( "warning"
            , "Invalid name scheme: 0000-should-produce-a-warning, file is \
               ignored" )
          ; "info", "Storing file: 1-test.yml in context"
          ; "info", "Storing file: 2-test.yml in context"
          ; "info", "Storing file: 3-test.yml in context"
          ]
        ~computed:!buff;
      same migration_list_testable ~expected ~computed)
;;

let test_init_on_dir_5_folder =
  test
    ~about:"init"
    ~desc:"When there is no error it should build the context"
    (fun () ->
      let buff = ref [] in
      let m1 = Migration.make 1 "test" "1-test.yml" [] [] Sha256.neutral in
      let m2 = Migration.(make 2 "test" "2-test.yml" [] [] (hash m1)) in
      let m3 = Migration.(make 3 "test" "3-test.yml" [] [] (hash m2)) in
      let m4 = Migration.(make 4 "sadlsad" "4-sadlsad.yml" [] [] (hash m3)) in
      let m5 = Migration.(make 5 "sadlsad" "5-sadlsad.yml" [] [] (hash m4)) in
      let m6 = Migration.(make 6 "sadlsad" "6-sadlsad.yml" [] [] (hash m5)) in
      let m7 = Migration.(make 7 "sadlsad" "7-sadlsad.yml" [] [] (hash m6)) in
      let m8 = Migration.(make 8 "sadlsad" "8-sadlsad.yml" [] [] (hash m7)) in
      let m9 = Migration.(make 9 "sadlsad" "9-sadlsad.yml" [] [] (hash m8)) in
      let m10 =
        Migration.(make 10 "sadlsad" "10-sadlsad.yml" [] [] (hash m9))
      in
      let m11 =
        Migration.(make 11 "sadlsad" "11-sadlsad.yml" [] [] (hash m10))
      in
      let expected =
        Ok
          [ 1, m1
          ; 2, m2
          ; 3, m3
          ; 4, m4
          ; 5, m5
          ; 6, m6
          ; 7, m7
          ; 8, m8
          ; 9, m9
          ; 10, m10
          ; 11, m11
          ]
      and computed = handle_init buff "dir-5" |> Try.map Context.to_list in
      same
        (list (pair string string))
        ~expected:
          [ "info", "Reading migration into dir-5"
          ; "info", "Storing file: 1-test.yml in context"
          ; "info", "Storing file: 2-test.yml in context"
          ; "info", "Storing file: 3-test.yml in context"
          ; "info", "Storing file: 4-sadlsad.yml in context"
          ; "info", "Storing file: 5-sadlsad.yml in context"
          ; "info", "Storing file: 6-sadlsad.yml in context"
          ; "info", "Storing file: 7-sadlsad.yml in context"
          ; "info", "Storing file: 8-sadlsad.yml in context"
          ; "info", "Storing file: 9-sadlsad.yml in context"
          ; "info", "Storing file: 10-sadlsad.yml in context"
          ; "info", "Storing file: 11-sadlsad.yml in context"
          ]
        ~computed:!buff;
      same migration_list_testable ~expected ~computed)
;;

let test_slice_1 =
  test
    ~about:"plan"
    ~desc:"when there is no migration it should returns an up list"
    (fun () ->
      let buff = ref [] in
      let m1 = Migration.make 1 "test" "1-test.yml" [] [] Sha256.neutral in
      let m2 = Migration.(make 2 "test" "2-test.yml" [] [] (hash m1)) in
      let m3 = Migration.(make 3 "test" "3-test.yml" [] [] (hash m2)) in
      let m4 = Migration.(make 4 "sadlsad" "4-sadlsad.yml" [] [] (hash m3)) in
      let m5 = Migration.(make 5 "sadlsad" "5-sadlsad.yml" [] [] (hash m4)) in
      let m6 = Migration.(make 6 "sadlsad" "6-sadlsad.yml" [] [] (hash m5)) in
      let m7 = Migration.(make 7 "sadlsad" "7-sadlsad.yml" [] [] (hash m6)) in
      let m8 = Migration.(make 8 "sadlsad" "8-sadlsad.yml" [] [] (hash m7)) in
      let m9 = Migration.(make 9 "sadlsad" "9-sadlsad.yml" [] [] (hash m8)) in
      let m10 =
        Migration.(make 10 "sadlsad" "10-sadlsad.yml" [] [] (hash m9))
      in
      let m11 =
        Migration.(make 11 "sadlsad" "11-sadlsad.yml" [] [] (hash m10))
      in
      let ctx = handle_init buff "dir-5" in
      let expected =
        Try.ok
          (Plan.Forward
             [ 1, m1
             ; 2, m2
             ; 3, m3
             ; 4, m4
             ; 5, m5
             ; 6, m6
             ; 7, m7
             ; 8, m8
             ; 9, m9
             ; 10, m10
             ; 11, m11
             ])
      and computed = Try.(ctx >>= fun s -> Context.plan ~current:0 s) in
      same Testable.(try_ migration_plan) ~expected ~computed)
;;

let test_slice_2 =
  test
    ~about:"plan"
    ~desc:"when there is some migrations it should returns an up list"
    (fun () ->
      let buff = ref [] in
      let m1 = Migration.make 1 "test" "1-test.yml" [] [] Sha256.neutral in
      let m2 = Migration.(make 2 "test" "2-test.yml" [] [] (hash m1)) in
      let m3 = Migration.(make 3 "test" "3-test.yml" [] [] (hash m2)) in
      let m4 = Migration.(make 4 "sadlsad" "4-sadlsad.yml" [] [] (hash m3)) in
      let m5 = Migration.(make 5 "sadlsad" "5-sadlsad.yml" [] [] (hash m4)) in
      let m6 = Migration.(make 6 "sadlsad" "6-sadlsad.yml" [] [] (hash m5)) in
      let m7 = Migration.(make 7 "sadlsad" "7-sadlsad.yml" [] [] (hash m6)) in
      let m8 = Migration.(make 8 "sadlsad" "8-sadlsad.yml" [] [] (hash m7)) in
      let m9 = Migration.(make 9 "sadlsad" "9-sadlsad.yml" [] [] (hash m8)) in
      let m10 =
        Migration.(make 10 "sadlsad" "10-sadlsad.yml" [] [] (hash m9))
      in
      let m11 =
        Migration.(make 11 "sadlsad" "11-sadlsad.yml" [] [] (hash m10))
      in
      let ctx = handle_init buff "dir-5" in
      let expected =
        Try.ok
          (Plan.Forward
             [ 3, m3
             ; 4, m4
             ; 5, m5
             ; 6, m6
             ; 7, m7
             ; 8, m8
             ; 9, m9
             ; 10, m10
             ; 11, m11
             ])
      and computed = Try.(ctx >>= fun s -> Context.plan ~current:2 s) in
      same Testable.(try_ migration_plan) ~expected ~computed)
;;

let test_slice_3 =
  test
    ~about:"plan"
    ~desc:"when the state is ok it should return Standby"
    (fun () ->
      let buff = ref [] in
      let ctx = handle_init buff "dir-5" in
      let expected = Try.ok Plan.Standby
      and computed = Try.(ctx >>= fun s -> Context.plan ~current:11 s) in
      same Testable.(try_ migration_plan) ~expected ~computed)
;;

let test_slice_4 =
  test
    ~about:"plan"
    ~desc:"when the state is ok it should return Nothing 2"
    (fun () ->
      let buff = ref [] in
      let m1 = Migration.make 1 "test" "1-test.yml" [] [] Sha256.neutral in
      let m2 = Migration.(make 2 "test" "2-test.yml" [] [] (hash m1)) in
      let m3 = Migration.(make 3 "test" "3-test.yml" [] [] (hash m2)) in
      let m4 = Migration.(make 4 "sadlsad" "4-sadlsad.yml" [] [] (hash m3)) in
      let _m5 = Migration.(make 5 "sadlsad" "5-sadlsad.yml" [] [] (hash m4)) in
      let ctx = handle_init buff "dir-5" in
      let expected = Try.ok Plan.Standby
      and computed =
        Try.(ctx >>= fun s -> Context.plan ~current:2 ~target:2 s)
      in
      same Testable.(try_ migration_plan) ~expected ~computed)
;;

let test_slice_5 =
  test
    ~about:"plan"
    ~desc:"when there is some migration it should returns an up list"
    (fun () ->
      let buff = ref [] in
      let m1 = Migration.make 1 "test" "1-test.yml" [] [] Sha256.neutral in
      let m2 = Migration.(make 2 "test" "2-test.yml" [] [] (hash m1)) in
      let m3 = Migration.(make 3 "test" "3-test.yml" [] [] (hash m2)) in
      let m4 = Migration.(make 4 "sadlsad" "4-sadlsad.yml" [] [] (hash m3)) in
      let _m5 = Migration.(make 5 "sadlsad" "5-sadlsad.yml" [] [] (hash m4)) in
      let ctx = handle_init buff "dir-5" in
      let expected = Try.ok (Plan.Forward [ 2, m2; 3, m3; 4, m4 ])
      and computed =
        Try.(ctx >>= fun s -> Context.plan ~current:1 ~target:4 s)
      in
      same Testable.(try_ migration_plan) ~expected ~computed)
;;

let test_slice_6 =
  test
    ~about:"plan"
    ~desc:"when there is some migration it should returns a down list 2"
    (fun () ->
      let buff = ref [] in
      let m1 = Migration.make 1 "test" "1-test.yml" [] [] Sha256.neutral in
      let m2 = Migration.(make 2 "test" "2-test.yml" [] [] (hash m1)) in
      let m3 = Migration.(make 3 "test" "3-test.yml" [] [] (hash m2)) in
      let m4 = Migration.(make 4 "sadlsad" "4-sadlsad.yml" [] [] (hash m3)) in
      let m5 = Migration.(make 5 "sadlsad" "5-sadlsad.yml" [] [] (hash m4)) in
      let ctx = handle_init buff "dir-5" in
      let expected =
        Try.ok (Plan.Backward ([ 5, m5; 4, m4 ], (3, m4.previous_hash)))
      and computed =
        Try.(ctx >>= fun s -> Context.plan ~current:5 ~target:3 s)
      in
      same Testable.(try_ migration_plan) ~expected ~computed)
;;

let test_slice_7 =
  test ~about:"plan" ~desc:"when there the target is too high" (fun () ->
      let buff = ref [] in
      let ctx = handle_init buff "dir-5" in
      let expected = Error.(to_try @@ migration_invalid_target ~given_target:13)
      and computed =
        Try.(ctx >>= fun s -> Context.plan ~current:5 ~target:13 s)
      in
      same Testable.(try_ migration_plan) ~expected ~computed)
;;

let test_slice_8 =
  test ~about:"plan" ~desc:"when there the current state is too high" (fun () ->
      let buff = ref [] in
      let ctx = handle_init buff "dir-5" in
      let expected = Error.(to_try @@ migration_invalid_state ~current_state:12)
      and computed =
        Try.(ctx >>= fun s -> Context.plan ~current:12 ~target:3 s)
      in
      same Testable.(try_ migration_plan) ~expected ~computed)
;;

let cases =
  ( "Context"
  , [ test_init_on_empty_folder
    ; test_init_on_inexistant_folder
    ; test_init_on_dir_1_folder
    ; test_init_on_dir_2_folder
    ; test_init_on_dir_3_folder
    ; test_init_on_dir_4_folder
    ; test_init_on_dir_5_folder
    ; test_slice_1
    ; test_slice_2
    ; test_slice_3
    ; test_slice_4
    ; test_slice_5
    ; test_slice_6
    ; test_slice_7
    ; test_slice_8
    ] )
;;
