open Lib_test
open Lib_migration
open Alcotest

let test_is_valid_filename_when_it_is_valid =
  test
    ~about:"is_valid_filename"
    ~desc:
      "When the given filename is valid it should returns a triple with the \
       expected data"
    (fun () ->
      let filename = "1-a_migration_example.yml" in
      let expected = Some (1, "a_migration_example", filename)
      and computed = Migration.is_valid_filename filename in
      same (option @@ triple int string string) ~computed ~expected)
;;

let test_is_valid_filename_when_it_is_invalid =
  test
    ~about:"is_valid_filename"
    ~desc:"When the given filename is invalid it should return None"
    (fun () ->
      let filename = "1a_migration_example.yml" in
      let expected = None
      and computed = Migration.is_valid_filename filename in
      same (option @@ triple int string string) ~computed ~expected)
;;

let test_is_valid_filename_when_it_is_invalid_with_a_negative_int =
  test
    ~about:"is_valid_filename"
    ~desc:
      "When the given filename start with a negative number, it should return \
       None"
    (fun () ->
      let filename = "-32-a_migration_example.yml" in
      let expected = None
      and computed = Migration.is_valid_filename filename in
      same (option @@ triple int string string) ~computed ~expected)
;;

let test_ensure_hash_is_idempotent =
  test
    ~desc:"hash"
    ~about:
      "Application of hash on the same migration should return the same hash"
    (fun () ->
      let open Migration in
      let expected =
        make
          55
          "a_migration_example"
          "55-a_migration_example.yml"
          [ ""; "1"; "2" ]
          [ "2"; "1"; "0" ]
          None
        |> hash
      and computed =
        make
          55
          "a_migration_example"
          "55-a_migration_example.yml"
          [ ""; "1"; "2" ]
          [ "2"; "1"; "0" ]
          None
        |> hash
      in
      same sha256_testable ~expected ~computed)
;;

let cases =
  ( "Migration"
  , [ test_is_valid_filename_when_it_is_valid
    ; test_is_valid_filename_when_it_is_invalid
    ; test_is_valid_filename_when_it_is_invalid_with_a_negative_int
    ; test_ensure_hash_is_idempotent
    ] )
;;
