type t = exn

exception Unknown
exception Unknown_with_message of string
exception List of t Preface.Nonempty_list.t
exception Required_field of string

exception
  Unexpected_value of
    { expected_type : string
    ; given_value : string
    }

exception
  Int_too_large of
    { given_value : int
    ; max_bound : int
    }

exception
  Int_too_small of
    { given_value : int
    ; min_bound : int
    }

exception String_is_empty
exception String_is_blank of string

exception
  Invalid_field of
    { key : string
    ; errors : t Preface.Nonempty_list.t
    }

exception Database of string
exception Invalid_log_level of string

let rec equal a b =
  match a, b with
  | Unknown, Unknown -> true
  | List list_a, List list_b -> Preface.Nonempty_list.equal equal list_a list_b
  | Unknown_with_message msg_a, Unknown_with_message msg_b ->
    String.equal msg_a msg_b
  | Required_field field_a, Required_field field_b ->
    String.equal field_a field_b
  | Unexpected_value a, Unexpected_value b ->
    String.equal a.expected_type b.expected_type
    && String.equal a.given_value b.given_value
  | Int_too_large a, Int_too_large b ->
    Int.equal a.given_value b.given_value && Int.equal a.max_bound b.max_bound
  | Int_too_small a, Int_too_small b ->
    Int.equal a.given_value b.given_value && Int.equal a.min_bound b.min_bound
  | String_is_blank a, String_is_blank b -> String.equal a b
  | String_is_empty, String_is_empty -> true
  | Invalid_field a, Invalid_field b ->
    String.equal a.key b.key
    && Preface.Nonempty_list.equal equal a.errors b.errors
  | Database a, Database b -> String.equal a b
  | Invalid_log_level a, Invalid_log_level b -> String.equal a b
  | a, b -> Preface.Exn.equal a b
;;

let rec pp ppf =
  let open Pp in
  function
  | Unknown_with_message message ->
    branch_with (double_quoted string) message ppf "Unknown_with_message"
  | List l -> branch_with (list pp) (Preface.Nonempty_list.to_list l) ppf "List"
  | Required_field f ->
    branch_with (double_quoted string) f ppf "Required_field"
  | Unexpected_value { given_value; expected_type } ->
    branch_with
      record
      [ field "given_value" given_value (double_quoted string)
      ; field "expected_type" expected_type (double_quoted string)
      ]
      ppf
      "Unexpected_value"
  | Int_too_large { given_value; max_bound } ->
    branch_with
      record
      [ field "given_value" given_value int; field "max_bound" max_bound int ]
      ppf
      "Int_too_large"
  | Int_too_small { given_value; min_bound } ->
    branch_with
      record
      [ field "given_value" given_value int; field "min_bound" min_bound int ]
      ppf
      "Int_too_large"
  | String_is_blank s ->
    branch_with (double_quoted string) s ppf "String_is_blank"
  | String_is_empty -> branch ppf "String_is_empty"
  | Invalid_field { key; errors } ->
    branch_with
      record
      [ field "key" key string
      ; field "errors" errors @@ Preface.Nonempty_list.pp pp
      ]
      ppf
      "Invalid_field"
  | Database _message -> branch ppf "Database"
  | Invalid_log_level message ->
    branch_with (double_quoted string) message ppf "Invalid_log_level"
  | Unknown | _ -> branch ppf "Unknown"
;;

let pp_desc ppf = function
  | Unknown_with_message message ->
    Format.fprintf
      ppf
      {|An unknown, with message: "%s"  error appeared|}
      message
  | List _list -> Format.fprintf ppf "There Several errors were found"
  | Required_field field ->
    Format.fprintf ppf {|The field [%s] is required|} field
  | Unexpected_value { given_value; expected_type } ->
    Format.fprintf
      ppf
      "The value [%s] cannot be treated as [%s]"
      given_value
      expected_type
  | Int_too_large { given_value; max_bound } ->
    Format.fprintf ppf "The value [%d] is > [%d]" given_value max_bound
  | Int_too_small { given_value; min_bound } ->
    Format.fprintf ppf "The value [%d] is < [%d]" given_value min_bound
  | String_is_blank s ->
    Format.fprintf ppf "The string %a is blank" Pp.(double_quoted string) s
  | String_is_empty -> Format.fprintf ppf "A given string is empty"
  | Invalid_field { key; errors = _ } ->
    Format.fprintf ppf "The field [%s] is invalid" key
  | Database message ->
    Format.fprintf
      ppf
      "An error occurred on the database side: %a"
      Pp.(double_quoted string)
      message
  | Invalid_log_level level ->
    Format.fprintf ppf "[%s] is not a known level" level
  | Unknown -> Format.fprintf ppf "An unknown error appeared"
  | e -> Preface.Exn.pp ppf e
;;

let as_try exn = Preface.Try.error exn

let as_validation exn =
  let nel = Preface.Nonempty_list.create exn in
  Preface.Validate.invalid nel
;;
