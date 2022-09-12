open Lib_test
open Lib_crypto
open Lib_migration

let test_is_valid_filename_when_it_is_valid =
  test
    ~about:"is_valid_filename"
    ~desc:
      "When the given filename is valid it should returns a triple with the \
       expected data"
    (fun () ->
    let filename = "1-a_migration_example.yml" in
    let expected =
      Migration.Valid_name_scheme
        { index = 1; label = "a_migration_example"; file = filename }
    and computed = Migration.is_valid_filename filename in
    same Testable.migration_file ~computed ~expected)
;;

let test_is_valid_filename_when_it_is_invalid =
  test
    ~about:"is_valid_filename"
    ~desc:"When the given filename is invalid it should return None"
    (fun () ->
    let filename = "1a_migration_example.yml" in
    let expected = Migration.Invalid_name_scheme { file = filename }
    and computed = Migration.is_valid_filename filename in
    same Testable.migration_file ~computed ~expected)
;;

let test_is_valid_filename_when_it_is_invalid_with_a_negative_int =
  test
    ~about:"is_valid_filename"
    ~desc:
      "When the given filename start with a negative number, it should return \
       None"
    (fun () ->
    let filename = "-32-a_migration_example.yml" in
    let expected = Migration.Invalid_name_scheme { file = filename }
    and computed = Migration.is_valid_filename filename in
    same Testable.migration_file ~computed ~expected)
;;

let test_ensure_hash_is_idempotent =
  test
    ~about:"hash"
    ~desc:
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
        Sha256.neutral
      |> hash
    and computed =
      make
        55
        "a_migration_example"
        "55-a_migration_example.yml"
        [ ""; "1"; "2" ]
        [ "2"; "1"; "0" ]
        Sha256.neutral
      |> hash
    in
    same Testable.sha256 ~expected ~computed)
;;

let cases =
  ( "Migration"
  , [ test_is_valid_filename_when_it_is_valid
    ; test_is_valid_filename_when_it_is_invalid
    ; test_is_valid_filename_when_it_is_invalid_with_a_negative_int
    ; test_ensure_hash_is_idempotent
    ] )
;;
