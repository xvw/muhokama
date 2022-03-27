open Lib_common

(** [Lib_form] is a library to facilitate the validation of forms, it is very
    similar to the functions exposed in {!module:Lib_common.Assoc}. But to avoid
    back-and-forth transformation in Json, it is tailored to process directly
    the results of the forms. This is a less generic version but it reduces the
    boilerplate needed to validate forms.

    {1 Core concepts}

    [Lib_form] is an opinionated version of the Applicative
    {!module:Lib_common.Validate}. Even if all combinators aim at producing
    validations, some design choices (a bit strict) impose the way to validate
    forms. For example, although data validation and field validation are both
    [Validate], fields are chained using [let operators] and validators using
    [infix operators].

    {2 Form validation}

    Even if we talk about form validation, in fact [Lib_form] allows to
    transform a source [(string * string) list] (that fit very well with HTTP
    queries) into a structured data by means of applicative validation.

    To do this, the validation library exposes two specific types:

    - ['a validated] which is data that has gone through a validation phase
    - [('a, 'b) validator] which is a function from ['a] to ['a validated].

    Let's start with a first example. Let's say we want to produce a simple pair
    of strings (firstname, lastname for example) :

    We would like to ensure that the pairs ["firstname", a_firstname] and
    ["lastname", a_lastname] are present in our source:

    {[
      let name_form source =
        let open Lib_form in
        let+ firstname = required source "firstname" is_string
        and+ lastname = required source "lastname" is_string in
        firstname, lastname
      ;;
    ]}

    If you run the validation using [run], for example:

    - [Lib_form.run ~name:"Name" name_form \["firstname", "Pierre"\]], the
      function will return an error because the field [lastname] is missing.
    - [Lib_form.run ~name:"Name" name_form \[\]], the function will return an
      error because fields [lastname, firstname] are missing.
    - [Lib_form.run ~name:"Name" name_form \["firstname", "Pierre"; "lastname", "R."\]]
      will succeed.

    The attribute named [~name] is only used to report the name in the error.

    {3 Dealing with optional fields}

    Let's say we want to have an optional field to assign a nickname to our
    user, i.e. we want to produce a value of type
    [(string * string * string option)], rather than [required], we can use
    [optional]:

    {[
      let name_form source =
        let open Lib_form in
        let+ firstname = required source "firstname" is_string
        and+ lastname = required source "lastname" is_string
        and+ nickname = optional source "nickname" is_string in
        firstname, lastname, nickname
      ;;
    ]}

    {3 Composing validators}

    Our first example was naive and only produced strings. Let's look at a more
    complicated example:

    {[
      type user =
        { id : string
        ; age : int option
        ; name : string option
        ; email : string
        }
    ]}

    To which we add some business rules:

    - [id] has to be an [UUID]
    - [age] if is defined should be greater than [7] and smaller than [100]
    - [name] if is defined should be not blank
    - [email] should be an email address.

    And as we can imagine that this form is used to register a user in a site,
    let's add a rule where the user must have checked the box "I accept the
    rules".

    Previously, we have seen that [let+] and [and+] allow to compose validation
    rules, i.e. values [`a validated].

    There are others, here are some of them:

    - [(a && b) x] will performs [b] (on the output of [a]) if [a x] is succeed
    - [(a || b) x] will performs [b x] if [a x] fails. Otherwise, it returns the
      result of [a x]
    - [a &&? b] and [a ||? b] that are like, respectively, [a && b] and
      [a ||? b] but acts on validator that returns options.

    Let's write a form validator for our type [user]:

    {[
      let user_form source =
        let open Lib_form in
        let+ id = required source "user_id" is_uuid
        and+ age = optional source "user_age" (is_int && bounded_to 7 100)
        and+ name = optional source "user_name" not_blank
        and+ email = required source "user_email" is_email
        and+ () = required source "accepted_rules" (is_bool && is_true) in
        { id; age; name; email }
      ;;
    ]}

    As you can see, the canonical scheme for a field is:
    [required_or_optional source field_name (validator && validators etc...)].
    This should be enough to build complex forms. Note that since a validator is
    just a function ['a -> 'b validated], you can easily build your own
    validators. *)

(** {1 Validation}

    A form encodes (usually) its data in a query-string, which corresponds to a
    serialization of the different parameters (we speak of {i urlencoded} data)
    which can easily be represented in an associative list :
    [(string * string) list].

    We can therefore validate these strings by transforming them into other data
    to produce, for example, integers, floats or defined types. *)

(** A validated value is something that was validated... *)
type 'a validated = 'a Validate.t

(** A validator is a function that takes an arbitrary value and returns the
    validated (or not) data. It is a kind of arrow in Kleisli's category. *)
type ('a, 'b) validator = 'a -> 'b validated

(** {2 Validator algebra}

    Composition of validators. *)

(** [validator_a && validator_b] will apply [validator_b] if [validator_a]
    succeed. *)
val ( &> ) : ('a, 'b) validator -> ('b, 'c) validator -> ('a, 'c) validator

(** [validator_a || validator_b] will apply [validator_b] if [validator_b]
    fails. Do not accumulate the error. *)
val ( <|> ) : ('a, 'b) validator -> ('a, 'b) validator -> ('a, 'b) validator

val ( & ) : 'a validated -> 'b validated -> ('a * 'b) validated

(** As [&>] but acting on validator that returns options. *)
val ( &? )
  :  ('a, 'b option) validator
  -> ('b, 'c) validator
  -> ('a, 'c option) validator

(** As [<|>] but acting on validator that returns options. *)
val ( <?> )
  :  ('a, 'b option) validator
  -> ('a, 'b option) validator
  -> ('a, 'b option) validator

(** [validator_a $ f] will performs [f] is [validator_a] succeed. It can be
    useful combined with [||] (since each branch should returns values from the
    same type). Ie:
    [validator_that_produces_int || (validator_that_produces_string $ int_of_string)] *)
val ( $ ) : ('a, 'b) validator -> ('b -> 'c) -> ('a, 'c) validator

(** {2 Validators}

    A list of already built validators *)

(** [from_predicate ?message predicate] returns the value [x] if [p x] wrapped
    in succeed. Otherwise it returns an error with the given [message]. For
    example:

    {[
      # from_predicate
          ~message:"value should be positive" (fun x >= 0) 15
    ]} *)
val from_predicate : ?message:string -> ('a -> bool) -> ('a, 'a) validator

(** a validator that ensure that a string is... a string. In fact, that
    validator is only for consistency. *)
val is_string : (string, string) validator

(** a validator that try to coerce a string to an int. *)
val is_int : (string, int) validator

(** a validator that try to coerce a string to a float. *)
val is_float : (string, float) validator

(** a validator that try to coerce a string to a bool. *)
val is_bool : (string, bool) validator

(** a validator that ensure that a string looks like an email. *)
val is_email : (string, string) validator

(** a validator that ensure that a string looks like an UUID (according to
    PGSQL). *)
val is_uuid : (string, string) validator

(** A validator that ensure that a given int is greater than an other given int.*)
val greater_than : int -> (int, int) validator

(** A validator that ensure that a given int is smaller than an other given int.*)
val smaller_than : int -> (int, int) validator

(** A validator that ensure that a given int is bounded into a range.*)
val bounded_to : int -> int -> (int, int) validator

(** A validator that ensure that a given string is not empty. *)
val not_empty : (string, string) validator

(** A validator that ensure that a given string is not blank. *)
val not_blank : (string, string) validator

(** A validator that ensure that a given boolean is true. *)
val is_true : (bool, unit) validator

(** A validator that ensure that a given boolean is false. *)
val is_false : (bool, unit) validator

(** {2 Run validators}*)

val run_validator : ('a, 'b) validator -> 'a -> 'b Validate.t

(** {2 Queries over fields} *)

val required
  :  (string * string) list
  -> string
  -> (string, 'a) validator
  -> 'a validated

val optional
  :  (string * string) list
  -> string
  -> (string, 'a) validator
  -> 'a option validated

val ensure_equality
  :  (string * string) list
  -> string
  -> string
  -> unit validated

val ( let+ ) : 'a validated -> ('a -> 'b, 'b) validator
val ( and+ ) : 'a validated -> ('b validated, 'a * 'b) validator

(** {2 Running validation} *)

val run
  :  ?name:string
  -> ((string * string) list -> 'a validated)
  -> (string * string) list
  -> 'a Try.t
