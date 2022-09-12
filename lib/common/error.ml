type error_tree =
  | Leaf of
      { label : string
      ; message : string option
      }
  | Node of
      { label : string
      ; tree : error_tree list
      }
[@@deriving yojson]

module IO = struct
  type t =
    | Unreadable_dir of { dirpath : string }
    | Unreadable_file of { filepath : string }
    | Invalid_loglevel of string

  let equal a b =
    match a, b with
    | Unreadable_dir { dirpath = a }, Unreadable_dir { dirpath = b } ->
      String.equal a b
    | Unreadable_file { filepath = a }, Unreadable_file { filepath = b } ->
      String.equal a b
    | Invalid_loglevel a, Invalid_loglevel b -> String.equal a b
    | _ -> false
  ;;

  let pp ppf = function
    | Unreadable_dir { dirpath } ->
      Fmt.pf ppf "Unreadable_dir { dirpath = %a }" Fmt.(quote string) dirpath
    | Unreadable_file { filepath } ->
      Fmt.pf ppf "Unreadable_file { filepath = %a }" Fmt.(quote string) filepath
    | Invalid_loglevel s ->
      Fmt.pf ppf "Invalid_loglevel %a" Fmt.(quote string) s
  ;;

  let normalize e =
    let label = "IO error"
    and message = Some (Fmt.str "%a" pp e) in
    Leaf { label; message }
  ;;
end

module Migration = struct
  type t =
    | Invalid_successor of
        { expected_index : int
        ; given_index : int
        }
    | Invalid_target of { given_target : int }
    | Invalid_state of { current_state : int }
    | Invalid_checksum of { given_index : int }

  let equal a b =
    match a, b with
    | Invalid_successor a, Invalid_successor b ->
      Int.equal a.expected_index b.expected_index
      && Int.equal a.given_index b.given_index
    | Invalid_target { given_target = a }, Invalid_target { given_target = b }
      -> Int.equal a b
    | Invalid_state { current_state = a }, Invalid_state { current_state = b }
      -> Int.equal a b
    | Invalid_checksum { given_index = a }, Invalid_checksum { given_index = b }
      -> Int.equal a b
    | _ -> false
  ;;

  let pp ppf = function
    | Invalid_successor { expected_index; given_index } ->
      Fmt.pf
        ppf
        "Invalid_successor { expected_index = %d; given_index = %d}"
        expected_index
        given_index
    | Invalid_target { given_target } ->
      Fmt.pf ppf "Invalid_target { given_target = %d }" given_target
    | Invalid_state { current_state } ->
      Fmt.pf ppf "Invalid_state { given_state = %d }" current_state
    | Invalid_checksum { given_index } ->
      Fmt.pf ppf "Invalid_state { given_index = %d }" given_index
  ;;

  let normalize e =
    let label = "Migration error"
    and message = Some (Fmt.str "%a" pp e) in
    Leaf { label; message }
  ;;
end

module Validable = struct
  type t =
    | Unconvertible_string of
        { given_value : string
        ; target_type : string
        }
    | Invalid_predicate of { with_message : string }
    | Is_smaller_than of
        { given_value : int
        ; min_bound : int
        }
    | Is_greater_than of
        { given_value : int
        ; max_bound : int
        }
    | Is_empty
    | Is_blank
    | Unexpected_representation of { expected_representation : string }

  let equal a b =
    match a, b with
    | Unconvertible_string a, Unconvertible_string b ->
      String.equal a.given_value b.given_value
      && String.equal a.target_type b.target_type
    | ( Invalid_predicate { with_message = a }
      , Invalid_predicate { with_message = b } ) -> String.equal a b
    | Is_smaller_than a, Is_smaller_than b ->
      Int.equal a.given_value b.given_value && Int.equal a.min_bound b.min_bound
    | Is_greater_than a, Is_greater_than b ->
      Int.equal a.given_value b.given_value && Int.equal a.max_bound b.max_bound
    | Is_empty, Is_empty -> true
    | Is_blank, Is_blank -> true
    | Unexpected_representation a, Unexpected_representation b ->
      String.equal a.expected_representation b.expected_representation
    | _ -> false
  ;;

  let pp ppf = function
    | Unconvertible_string { given_value; target_type } ->
      Fmt.pf
        ppf
        "Unconvertible_string { given_value = %a; target_type = %s }"
        Fmt.(quote string)
        given_value
        target_type
    | Invalid_predicate { with_message } ->
      Fmt.pf
        ppf
        "Invalid_predicate { with_message = %a }"
        Fmt.(quote string)
        with_message
    | Is_smaller_than { given_value; min_bound } ->
      Fmt.pf
        ppf
        "Is_smaller_than { given_value = %d; min_bound = %d }"
        given_value
        min_bound
    | Is_greater_than { given_value; max_bound } ->
      Fmt.pf
        ppf
        "Is_greater_than { given_value = %d;  max_bound = %d }"
        given_value
        max_bound
    | Is_empty -> Fmt.pf ppf "Is_empty"
    | Is_blank -> Fmt.pf ppf "Is_blank"
    | Unexpected_representation { expected_representation } ->
      Fmt.pf
        ppf
        "Unexpected_representation { expected_representation = %s }"
        expected_representation
  ;;

  let normalize e =
    let label = "Validation_error"
    and message = Some (Fmt.str "%a" pp e) in
    Leaf { label; message }
  ;;
end

module Field = struct
  type 'a t =
    | Missing of { name : string }
    | Invalid of
        { name : string
        ; errors : 'a Preface.Nonempty_list.t
        }

  let equal eq a b =
    match a, b with
    | Missing a, Missing b -> String.equal a.name b.name
    | Invalid a, Invalid b ->
      String.equal a.name b.name
      && Preface.Nonempty_list.equal eq a.errors b.errors
    | _ -> false
  ;;

  let pp pp' ppf = function
    | Missing field ->
      Fmt.pf ppf "Missing { name = %a}" Fmt.(quote string) field.name
    | Invalid x ->
      Fmt.pf
        ppf
        "Invalid { name = %a; errors = %a }"
        Fmt.(quote string)
        x.name
        Fmt.(list pp')
        (Preface.Nonempty_list.to_list x.errors)
  ;;

  let normalize renormalize = function
    | Missing { name } ->
      let label = "Field <" ^ name ^ "> is missing"
      and message = None in
      Leaf { label; message }
    | Invalid { name; errors } ->
      let label = "Field <" ^ name ^ "> is invalid" in
      let tree = Preface.Nonempty_list.(map renormalize errors |> to_list) in
      Node { label; tree }
  ;;
end

module Category = struct
  type t =
    | Name_already_taken of string
    | Id_not_found of string
    | Name_not_found of string
    | No_category

  let equal a b =
    match a, b with
    | Name_already_taken a, Name_already_taken b -> String.equal a b
    | Id_not_found a, Id_not_found b -> String.equal a b
    | Name_not_found a, Name_not_found b -> String.equal a b
    | No_category, No_category -> true
    | _ -> false
  ;;

  let pp ppf = function
    | Name_already_taken x ->
      Fmt.pf ppf "Name_already_taken %a" Fmt.(quote string) x
    | Id_not_found x -> Fmt.pf ppf "Id_not_found %a" Fmt.(quote string) x
    | Name_not_found x -> Fmt.pf ppf "Name_not_found %a" Fmt.(quote string) x
    | No_category -> Fmt.pf ppf "No_category"
  ;;

  let normalize = function
    | Name_already_taken label ->
      let message = Some "Category name is already taken" in
      Leaf { label; message }
    | Name_not_found label ->
      let message = Some "Unable to find the category" in
      Leaf { label; message }
    | Id_not_found label ->
      let message = Some "Unable to find the category" in
      Leaf { label; message }
    | No_category ->
      let label = "No category"
      and message = Some "At least one category must be present" in
      Leaf { label; message }
  ;;
end

module Topic = struct
  type t = Id_not_found of string

  let equal a b =
    match a, b with
    | Id_not_found a, Id_not_found b -> String.equal a b
  ;;

  let pp ppf = function
    | Id_not_found a -> Fmt.pf ppf "Id_not_found %a" Fmt.(quote string) a
  ;;

  let normalize = function
    | Id_not_found label ->
      let message = Some "Unable to find the topic" in
      Leaf { label; message }
  ;;
end

module User = struct
  type t =
    | Email_already_taken of string
    | Username_already_taken of string
    | Identity_already_taken of
        { username : string
        ; email : string
        }
    | Invalid_state of string
    | Not_found of string
    | Id_not_found of string
    | Unactivated of string
    | Invalid_state_change of string

  let equal a b =
    match a, b with
    | Email_already_taken a, Email_already_taken b -> String.equal a b
    | Username_already_taken a, Username_already_taken b -> String.equal a b
    | Identity_already_taken a, Identity_already_taken b ->
      String.equal a.email b.email && String.equal a.username b.username
    | Invalid_state a, Invalid_state b -> String.equal a b
    | Not_found a, Not_found b -> String.equal a b
    | Id_not_found a, Id_not_found b -> String.equal a b
    | Unactivated a, Unactivated b -> String.equal a b
    | Invalid_state_change a, Invalid_state_change b -> String.equal a b
    | _ -> false
  ;;

  let pp ppf = function
    | Email_already_taken email ->
      Fmt.pf ppf "Email_already_taken %a" Fmt.(quote string) email
    | Username_already_taken name ->
      Fmt.pf ppf "Username_already_taken %a" Fmt.(quote string) name
    | Identity_already_taken { username; email } ->
      Fmt.pf
        ppf
        "Identity_already_taken { username = %a; email = %a }"
        Fmt.(quote string)
        username
        Fmt.(quote string)
        email
    | Invalid_state s -> Fmt.pf ppf "Invalid_state %a" Fmt.(quote string) s
    | Not_found s -> Fmt.pf ppf "Not_found %a" Fmt.(quote string) s
    | Id_not_found s -> Fmt.pf ppf "Not_found %a" Fmt.(quote string) s
    | Unactivated s -> Fmt.pf ppf "Unactivated %a" Fmt.(quote string) s
    | Invalid_state_change s ->
      Fmt.pf ppf "Invalid_state_change %a" Fmt.(quote string) s
  ;;

  let rec normalize = function
    | Email_already_taken label ->
      let message = Some "Email is already registered" in
      Leaf { label; message }
    | Username_already_taken label ->
      let message = Some "Username is already registered" in
      Leaf { label; message }
    | Invalid_state s ->
      let label = "Unkown user state" in
      let message = Some Fmt.(str "%a is an unknown state" (quote string) s) in
      Leaf { label; message }
    | Identity_already_taken { username; email } ->
      let label = "Username and email are already registered" in
      let tree =
        [ normalize @@ Email_already_taken email
        ; normalize @@ Username_already_taken username
        ]
      in
      Node { label; tree }
    | Not_found label | Id_not_found label ->
      let message = Some "Not found" in
      Leaf { label; message }
    | Unactivated label ->
      let message = Some "Not activated" in
      Leaf { label; message }
    | Invalid_state_change m ->
      let message = Some m
      and label = "Invalid state change" in
      Leaf { message; label }
  ;;
end

module Form = struct
  type t =
    | Expired of (string * string) list * float
    | Wrong_session of (string * string) list
    | Invalid_token of (string * string) list
    | Missing_token of (string * string) list
    | Many_tokens of (string * string) list
    | Wrong_content_type

  type 'a raw =
    [ `Expired of 'a * float
    | `Wrong_session of 'a
    | `Invalid_token of 'a
    | `Missing_token of 'a
    | `Many_tokens of 'a
    | `Wrong_content_type
    | `Wrong_session of 'a
    ]

  let eq_list = List.equal (Preface.Pair.equal String.equal String.equal)

  let equal a b =
    match a, b with
    | Expired (la, ea), Expired (lb, eb) -> eq_list la lb && Float.equal ea eb
    | Wrong_session a, Wrong_session b
    | Missing_token a, Missing_token b
    | Invalid_token a, Invalid_token b
    | Many_tokens a, Many_tokens b -> eq_list a b
    | Wrong_content_type, Wrong_content_type -> true
    | _, _ -> false
  ;;

  let pp ppf = function
    | Expired (f, expiration) ->
      Fmt.pf
        ppf
        "Expired %a, %a"
        Fmt.(list @@ pair (quote string) (quote string))
        f
        Fmt.float
        expiration
    | Wrong_session f ->
      Fmt.pf
        ppf
        "Wrong_session %a"
        Fmt.(list @@ pair (quote string) (quote string))
        f
    | Invalid_token f ->
      Fmt.pf
        ppf
        "Invalid_token %a"
        Fmt.(list @@ pair (quote string) (quote string))
        f
    | Missing_token f ->
      Fmt.pf
        ppf
        "Missing_token %a"
        Fmt.(list @@ pair (quote string) (quote string))
        f
    | Many_tokens f ->
      Fmt.pf
        ppf
        "Many_token %a"
        Fmt.(list @@ pair (quote string) (quote string))
        f
    | Wrong_content_type -> Fmt.pf ppf "Wrong_content_type"
  ;;

  let normalize = function
    | Expired _ -> Leaf { label = "POST session expired"; message = None }
    | Wrong_session _ -> Leaf { label = "Wrong session"; message = None }
    | Invalid_token _ | Missing_token _ | Many_tokens _ ->
      Leaf { label = "Invalid CSRF token"; message = None }
    | Wrong_content_type ->
      Leaf { label = "Wrong content type"; message = None }
  ;;
end

type t =
  | Migration of Migration.t
  | IO of IO.t
  | Validation of Validable.t
  | Database of string
  | Field of t Field.t
  | User of User.t
  | Category of Category.t
  | Topic of Topic.t
  | Form of Form.t
  | Yaml of string
  | Invalid_object of
      { name : string
      ; errors : t Preface.Nonempty_list.t
      }
  | Invalid_form of
      { name : string
      ; errors : t Preface.Nonempty_list.t
      }

let yaml s = Yaml s
let database s = Database s

let migration_invalid_successor ~expected_index ~given_index =
  Migration (Migration.Invalid_successor { expected_index; given_index })
;;

let migration_invalid_target ~given_target =
  Migration (Migration.Invalid_target { given_target })
;;

let migration_invalid_state ~current_state =
  Migration (Migration.Invalid_state { current_state })
;;

let migration_invalid_checksum ~given_index =
  Migration (Migration.Invalid_checksum { given_index })
;;

let io_unreadable_dir ~dirpath = IO (IO.Unreadable_dir { dirpath })
let io_unreadable_file ~filepath = IO (IO.Unreadable_file { filepath })
let io_invalid_loglevel level = IO (IO.Invalid_loglevel level)

let validation_unconvertible_string ~given_value ~target_type =
  Validation (Validable.Unconvertible_string { given_value; target_type })
;;

let validation_invalid_predicate ~with_message =
  Validation (Validable.Invalid_predicate { with_message })
;;

let validation_is_smaller_than ~given_value ~min_bound =
  Validation (Validable.Is_smaller_than { given_value; min_bound })
;;

let validation_is_greater_than ~given_value ~max_bound =
  Validation (Validable.Is_greater_than { given_value; max_bound })
;;

let validation_is_blank = Validation Validable.Is_blank
let validation_is_empty = Validation Validable.Is_empty

let validation_unexpected_representation ~expected_representation =
  Validation (Validable.Unexpected_representation { expected_representation })
;;

let field_missing ~name = Field (Field.Missing { name })
let field_invalid ~name ~errors = Field (Field.Invalid { name; errors })

let user_name_already_taken username =
  User (User.Username_already_taken username)
;;

let user_email_already_taken email = User (User.Email_already_taken email)

let user_already_taken ~username ~email =
  User (User.Identity_already_taken { username; email })
;;

let user_invalid_state state = User (User.Invalid_state state)
let invalid_object ~name ~errors = Invalid_object { name; errors }
let invalid_form ~name ~errors = Invalid_form { name; errors }
let user_not_found email = User (User.Not_found email)
let user_id_not_found id = User (User.Id_not_found id)
let user_not_activated email = User (User.Unactivated email)

let user_already_inactive =
  User (User.Invalid_state_change "the user is already at the bottom")
;;

let user_is_admin =
  User (User.Invalid_state_change "you can not change administrator state")
;;

let category_name_already_taken x = Category (Category.Name_already_taken x)
let category_name_not_found x = Category (Category.Name_not_found x)
let category_id_not_found x = Category (Category.Id_not_found x)
let category_absent = Category Category.No_category
let topic_id_not_found id = Topic (Topic.Id_not_found id)

let form_error err =
  Form
    (match err with
     | `Expired (f, e) -> Form.Expired (f, e)
     | `Wrong_session f -> Form.Wrong_session f
     | `Invalid_token f -> Form.Invalid_token f
     | `Missing_token f -> Form.Missing_token f
     | `Many_tokens f -> Form.Many_tokens f
     | `Wrong_content_type -> Form.Wrong_content_type)
;;

let rec equal a b =
  match a, b with
  | Migration a, Migration b -> Migration.equal a b
  | Database a, Database b -> String.equal a b
  | Yaml a, Yaml b -> String.equal a b
  | IO a, IO b -> IO.equal a b
  | Validation a, Validation b -> Validable.equal a b
  | Field a, Field b -> Field.equal equal a b
  | Invalid_object a, Invalid_object b ->
    String.equal a.name b.name
    && Preface.Nonempty_list.equal equal a.errors b.errors
  | Invalid_form a, Invalid_form b ->
    String.equal a.name b.name
    && Preface.Nonempty_list.equal equal a.errors b.errors
  | User a, User b -> User.equal a b
  | Form a, Form b -> Form.equal a b
  | Category a, Category b -> Category.equal a b
  | Topic a, Topic b -> Topic.equal a b
  | _ -> false
;;

let rec pp ppf = function
  | Migration err -> Fmt.pf ppf "Error.Migration (%a)" Migration.pp err
  | IO err -> Fmt.pf ppf "Error.IO (%a)" IO.pp err
  | Validation err -> Fmt.pf ppf "Error.Validation (%a)" Validable.pp err
  | Database err -> Fmt.pf ppf "Error.Database (%a)" Fmt.(quote string) err
  | Yaml err -> Fmt.pf ppf "Error.Yaml (%a)" Fmt.(quote string) err
  | Field f -> Fmt.pf ppf "Error.Field (%a)" (Field.pp pp) f
  | User u -> Fmt.pf ppf "Error.User (%a)" User.pp u
  | Category c -> Fmt.pf ppf "Error.Category (%a)" Category.pp c
  | Topic t -> Fmt.pf ppf "Error.Topic (%a)" Topic.pp t
  | Form f -> Fmt.pf ppf "Error.Form (%a)" Form.pp f
  | Invalid_object { name; errors } ->
    Fmt.pf
      ppf
      "Error.Invald_object { name = %a; errors = %a }"
      Fmt.(quote string)
      name
      Fmt.(list pp)
      (Preface.Nonempty_list.to_list errors)
  | Invalid_form { name; errors } ->
    Fmt.pf
      ppf
      "Error.Invald_form { name = %a; errors = %a }"
      Fmt.(quote string)
      name
      Fmt.(list pp)
      (Preface.Nonempty_list.to_list errors)
;;

let to_try v = Error v

let to_validate v =
  let open Preface in
  Validation.Invalid (Nonempty_list.create v)
;;

let collapse_for_field name = function
  | Preface.Validation.Valid x -> Preface.Validation.Valid x
  | Invalid errors -> to_validate @@ field_invalid ~name ~errors
;;

let rec normalize = function
  | Yaml message -> Leaf { label = "Yaml error"; message = Some message }
  | Database message ->
    Leaf { label = "Database error"; message = Some message }
  | IO err -> IO.normalize err
  | Validation err -> Validable.normalize err
  | Migration err -> Migration.normalize err
  | Field f -> Field.normalize normalize f
  | Form f -> Form.normalize f
  | User u -> User.normalize u
  | Category c -> Category.normalize c
  | Topic t -> Topic.normalize t
  | Invalid_object { name; errors } ->
    let label = "Object <" ^ name ^ "> is invalid"
    and tree = Preface.Nonempty_list.(map normalize errors |> to_list) in
    Node { label; tree }
  | Invalid_form { name; errors } ->
    let label = "Form <" ^ name ^ "> is invalid"
    and tree = Preface.Nonempty_list.(map normalize errors |> to_list) in
    Node { label; tree }
;;
