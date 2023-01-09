(** An endpoint is used to describe the pairing of an HTTP method (currently
    [GET] or [POST]) and a path. An endpoint can be used to generate links or to
    build handlers whose callback functions correspond to the variable parts of
    a path. *)

(** {1 Path}

    The [Path] describes the URL fragment (without the GET variables), its
    purpose is to represent a URL path associated with a continuation, a bit
    like [Scanf]. [Path.t] is parameterized by two types, the first one
    corresponds to the type of the callback to provide, and the second one
    corresponds to the value that the callback must return.

    Let's take these URLs (written in pseudo-code) as an example (we suppose
    that [:type] defines a variant part of type [type]. ):

    - [/a/b/c] will produce [('a, 'a) path] Because the path has no variable
      components.
    - [/a/:int/b/:string] will produce [('int -> string -> 'a, 'a) path].

    From the way constructors of type [path] produce typed values, it can be
    assumed that in type [('handler_type, 'return_type) path], ['handler_type]
    must be a function that returns a ['handler_type]. *)

type ('handler_function, 'handler_return) path
and 'value_type variable

(** {2 Path creation}

    Creating [path] is just composing constants fragments with variables. We use
    a value of type ['a variable] for variable part. Here is a representation of
    the paths given in the introduction:

    - [/a/b/c] is [~/"a"/"b"/"c"]
    - [/a/:int/b/:string] is [~/"a"/:int/"b"/:string] *)

(** [root] is the path [/]. It should be used to describe the root of the web
    application.*)
val root : ('handler_return, 'handler_return) path

(** Add a constant part to a path. *)
val ( / )
  :  ('handler_function, 'handler_return) path
  -> string
  -> ('handler_function, 'handler_return) path

(** Add a variable part to a path.*)
val ( /: )
  :  ('handler_function, 'new_variable -> 'handler_return) path
  -> 'new_variable variable
  -> ('handler_function, 'handler_return) path

(** [~/constant] is equivalent to [root / constant]. *)
val ( ~/ ) : string -> ('handler_return, 'handler_return) path

(** [~/:variable] is equivalent to [root /: variable]. *)
val ( ~/: )
  :  'new_variable variable
  -> ('new_variable -> 'handler_return, 'handler_return) path

(** Describes a variable of type [string]. *)
val string : string variable

(** Describes a variable of type [int]. *)
val int : int variable

(** Describes a variable of type [char]. *)
val char : char variable

(** Describes a variable of type [float]. *)
val float : float variable

(** Describes a variable of type [bool]. *)
val bool : bool variable

(** {1 Endpoint}

    As mentioned in the introduction, an endpoint is a pair of a method and a
    [path]. *)

(** HTTP methods.*)
type method_ =
  [ `GET
  | `POST
  | `PUT
  | `DELETE
  | `HEAD
  | `CONNECT
  | `OPTIONS
  | `TRACE
  | `PATCH
  | `Method of string
  ]

(** Endpoint description. Since an Endpoint wrap a [path], [`handler_function]
    and ['handler_return] share the same meaning of those in [path].*)
type ('method_, 'handler_function, 'handler_return) t

(** {2 Defining Endpoints} *)

(** [get path] describes a GET endpoint for the given path [p]. *)
val get
  :  ('handler_function, 'handler_return) path
  -> ([ `GET ], 'handler_function, 'handler_return) t

(** [post path] describes a POST endpoint for the given path [p]. *)
val post
  :  ('handler_function, 'handler_return) path
  -> ([ `POST ], 'handler_function, 'handler_return) t

(** {2 Action on Endpoint} *)

(** [handle_link endpoint handler] will produces a link and'll apply a function
    on the result. For example:

    {[
      let endpoint = Endpoint.(get (~/"name" /: string / "age" /: int))

      let link =
        Endpoint.handle_link
          endpoint
          (fun link -> Format.asprintf "link = %s" link)
          "Antoine"
          77
      ;;
    ]} *)
val handle_link
  :  ('method_, 'handler_function, 'handler_return) t
  -> (string -> 'handler_return)
  -> 'handler_function

(** [href endpoint ...args] will produce a link without handler. For example:

    {[
      let endpoint = Endpoint.(get (~/"name" /: string / "age" /: int))
      let link = Endpoint.href endpoint "Antoine" 77
    ]}

    Since there is no reason for generating a [href] for a [POST] endpoint, this
    function typecheck only if the endpoint is a [GET]. *)
val href : ([ `GET ], 'handler_function, string) t -> 'handler_function

val handle_href
  :  ([ `GET ], 'handler_function, 'handler_return) t
  -> (string -> 'handler_return)
  -> 'handler_function

(** A Dream version of redirection. *)
val redirect
  :  ?anchor:string
  -> ?status:[< Dream.redirection ]
  -> ?code:int
  -> ?headers:(string * string) list
  -> ( [ `GET ]
     , 'handler_function
     , Dream.request -> Dream.response Dream.promise )
     t
  -> 'handler_function

(** [form_method endpoint] gives a Tyxml's representation of the form method. *)
val form_method : (_, _, _) t -> [> `Get | `Post ]

(** [form_action endpoint] gives the value of action (form attribute). *)
val form_action : ('method_, 'handler_function, string) t -> 'handler_function

(** [form_method_action] returns a couple of the Tyxml compliant form method and
    the uri of the action field.*)
val form_method_action
  :  ('method_, 'handler_function, [> `Get | `Post ] * string) t
  -> 'handler_function

val handle_form
  :  ?anchor:string
  -> ('method_, 'handler_function, 'handler_return) t
  -> ([> `Get | `Post ] -> string -> 'handler_return)
  -> 'handler_function

(** Perform a handler related to an endpoint iff the endpoint as the proper
    method and try to extract data from the given uri. *)
val handle
  :  ('method_, 'handler_function, 'handler_return) t
  -> method_
  -> string list
  -> ('handler_return -> 'a)
  -> 'handler_function
  -> 'a option
