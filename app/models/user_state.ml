open Lib_common
open Util

type t =
  | Inactive
  | Member
  | Moderator
  | Admin
  | Unknown of string

let equal a b =
  match a, b with
  | Inactive, Inactive -> true
  | Member, Member -> true
  | Moderator, Moderator -> true
  | Admin, Admin -> true
  | Unknown a, Unknown b -> String.equal a b
  | _ -> false
;;

let pp ppf = function
  | Inactive -> Fmt.pf ppf "inactive"
  | Member -> Fmt.pf ppf "member"
  | Moderator -> Fmt.pf ppf "moderator"
  | Admin -> Fmt.pf ppf "admin"
  | Unknown s -> Fmt.pf ppf "%s" s
;;

let to_string = Fmt.str "%a" pp

let try_state state =
  match normalize_name state with
  | "inactive" -> Ok Inactive
  | "member" -> Ok Member
  | "moderator" -> Ok Moderator
  | "admin" -> Ok Admin
  | s -> Error.(to_try @@ user_invalid_state s)
;;

let validate_state state =
  match try_state state with
  | Ok s -> Validate.valid s
  | Error err -> Error.(to_validate err)
;;

let from_string state =
  match normalize_name state with
  | "inactive" -> Inactive
  | "member" -> Member
  | "moderator" -> Moderator
  | "admin" -> Admin
  | s -> Unknown s
;;

let to_int = function
  | Inactive -> 0
  | Member -> 1
  | Moderator -> 2
  | Admin -> 3
  | Unknown _ -> -1
;;

let compare a b =
  let ia = to_int a
  and ib = to_int b in
  Int.compare ia ib
;;

let is_active = function
  | Member | Moderator | Admin -> true
  | Inactive | Unknown _ -> false
;;

type filter =
  | All
  | Is_active
  | Is_moderable
  | Is_administrator
  | Has_power
  | Is_moderator
  | Is_member
  | Is_inactive
  | Is_unknown
  | Is_unknown_with of string

let all = All
let active = Is_active
let moderable = Is_moderable
let admin = Is_administrator
let with_power = Has_power
let moderator = Is_moderator
let member = Is_member
let inactive = Is_inactive

let unknown ?state () =
  Option.fold ~none:Is_unknown ~some:(fun x -> Is_unknown_with x) state
;;

type filtering_strategy =
  | Include of t list
  | Exclude of t list

let join_user_state prefix filter =
  let neutral, op, eq, list =
    match filter with
    | Include l -> "false", "OR", "=", l
    | Exclude l -> "true", "AND", "<>", l
  in
  match list with
  | [] -> neutral
  | states ->
    List.fold_left
      (fun (acc, flag) state ->
        let operator = Option.fold ~none:"" ~some:(Fun.const op) flag in
        ( Fmt.str "%s%s %suser_state %s '%a' " acc operator prefix eq pp state
        , Some () ))
      (" ", None)
      states
    |> fst
;;

let compute_filter = function
  | All -> Exclude []
  | Is_active -> Include [ Member; Moderator; Admin ]
  | Is_moderable -> Exclude [ Admin ]
  | Is_administrator -> Include [ Admin ]
  | Is_moderator -> Include [ Moderator ]
  | Is_member -> Include [ Member ]
  | Is_inactive -> Include [ Inactive ]
  | Is_unknown -> Exclude [ Member; Moderator; Admin; Inactive ]
  | Is_unknown_with f -> Include [ Unknown f ]
  | Has_power -> Include [ Moderator; Admin ]
;;

let pp_filter ?(prefix = "") () ppf filter =
  Fmt.pf
    ppf
    "%s"
    (String.trim @@ join_user_state prefix @@ compute_filter filter)
;;
