open Alcotest
open Models.User.State
open Lib_test

let test_all =
  test
    ~about:"all & pp_filter"
    ~desc:"test for [all] and [pp_filter]"
    (fun () ->
      let computed = Fmt.str "%a" (pp_filter ()) all
      and expected = "true" in
      same string ~expected ~computed)
;;

let test_active =
  test
    ~about:"active & pp_filter"
    ~desc:"test for [active] and [pp_filter]"
    (fun () ->
      let computed = Fmt.str "%a" (pp_filter ()) active
      and expected =
        "user_state = 'member' OR user_state = 'moderator' OR user_state = \
         'admin'"
      in
      same string ~expected ~computed)
;;

let test_moderable =
  test
    ~about:"moderable & pp_filter"
    ~desc:"test for [moderable] and [pp_filter]"
    (fun () ->
      let computed = Fmt.str "%a" (pp_filter ()) moderable
      and expected = "user_state <> 'admin'" in
      same string ~expected ~computed)
;;

let test_admin =
  test
    ~about:"admin & pp_filter"
    ~desc:"test for [admin] and [pp_filter]"
    (fun () ->
      let computed = Fmt.str "%a" (pp_filter ()) admin
      and expected = "user_state = 'admin'" in
      same string ~expected ~computed)
;;

let test_moderator =
  test
    ~about:"moderator & pp_filter"
    ~desc:"test for [moderator] and [pp_filter]"
    (fun () ->
      let computed = Fmt.str "%a" (pp_filter ()) moderator
      and expected = "user_state = 'moderator'" in
      same string ~expected ~computed)
;;

let test_member =
  test
    ~about:"member & pp_filter"
    ~desc:"test for [member] and [pp_filter]"
    (fun () ->
      let computed = Fmt.str "%a" (pp_filter ()) member
      and expected = "user_state = 'member'" in
      same string ~expected ~computed)
;;

let test_inactive =
  test
    ~about:"inactive & pp_filter"
    ~desc:"test for [inactive] and [pp_filter]"
    (fun () ->
      let computed = Fmt.str "%a" (pp_filter ()) inactive
      and expected = "user_state = 'inactive'" in
      same string ~expected ~computed)
;;

let test_with_power =
  test
    ~about:"with_power & pp_filter"
    ~desc:"test for [with_power] and [pp_filter]"
    (fun () ->
      let computed = Fmt.str "%a" (pp_filter ()) with_power
      and expected = "user_state = 'moderator' OR user_state = 'admin'" in
      same string ~expected ~computed)
;;

let cases =
  ( "User_state"
  , [ test_all
    ; test_active
    ; test_moderable
    ; test_admin
    ; test_moderator
    ; test_member
    ; test_inactive
    ; test_with_power
    ] )
;;
