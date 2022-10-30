include Stdlib.String

let replace ~pattern ~by str =
  Str.global_replace (Str.regexp pattern) by str
