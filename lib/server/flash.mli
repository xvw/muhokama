module Main : sig
  val action : Dream.request -> string -> unit
  val info : Dream.request -> string -> unit
  val alert : Dream.request -> string -> unit
  val error_tree : Dream.request -> Lib_common.Error.t -> unit
  val nothing : Dream.request -> unit
  val fetch : Dream.request -> Lib_ui.Notif.t option
end
