type 'a t = Format.formatter -> 'a -> unit
type packed = E : ('a * 'a t) -> packed

let pack value pp = E (value, pp)
let string ppf = Format.fprintf ppf "%s"
let int ppf = Format.fprintf ppf "%d"
let double_quoted aux ppf x = Format.fprintf ppf {|"%a"|} aux x
let simple_quoted aux ppf x = Format.fprintf ppf {|'%a'|} aux x
let unit ppf () = Format.fprintf ppf "()"

let rec pp_record_fields ppf = function
  | [] -> ()
  | (key, E (value, pp)) :: (_ :: _ as xs) ->
    let () = Format.fprintf ppf "@[<v 1>%s =@ %a;@ @]" key pp value in
    pp_record_fields ppf xs
  | (key, E (value, pp)) :: xs ->
    let () = Format.fprintf ppf "@[<v 1>%s =@ %a@]" key pp value in
    pp_record_fields ppf xs
;;

let record ppf repr = Format.fprintf ppf "{ @[%a@] }" pp_record_fields repr
let field key value pp = key, pack value pp
let branch = string

let branch_with pp x ppf constr =
  Format.fprintf ppf "@[<1>%s@ @[%a@]@]" constr pp x
;;

let list pp ppf list =
  let pp_sep ppf () = Format.fprintf ppf ";@ " in
  Format.(fprintf ppf "@[[ %a ]@]" (pp_print_list ~pp_sep pp) list)
;;
