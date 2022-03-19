open Lib_crypto

type t =
  | Forward of (int * Migration.t) list
  | Backward of (int * Migration.t) list * (int * Sha256.t)
    (* We keep a trace of the previous hash. *)
  | Standby

let equal a b =
  match a, b with
  | Forward l, Forward r ->
    List.equal (Preface.Pair.equal Int.equal Migration.equal) l r
  | Backward (l, witness_l), Backward (r, witness_r) ->
    List.equal (Preface.Pair.equal Int.equal Migration.equal) l r
    && Preface.Pair.equal Int.equal Sha256.equal witness_l witness_r
  | Standby, Standby -> true
  | _ -> false
;;

let pp ppf = function
  | Standby -> Fmt.pf ppf "Standby"
  | Forward l -> Fmt.pf ppf "Forward %a" Fmt.(list @@ pair int Migration.pp) l
  | Backward (l, w) ->
    Fmt.pf
      ppf
      "Backward (%a, %a)"
      Fmt.(list @@ pair int Migration.pp)
      l
      Fmt.(pair int Sha256.pp)
      w
;;
