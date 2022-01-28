type t =
  string
  * [ `Button
    | `Checkbox
    | `Color
    | `Date
    | `Datetime
    | `Datetime_local
    | `Email
    | `File
    | `Hidden
    | `Image
    | `Month
    | `Number
    | `Password
    | `Radio
    | `Range
    | `Reset
    | `Search
    | `Submit
    | `Tel
    | `Text
    | `Time
    | `Url
    | `Week
    ]

type t2 = t * t
type t3 = t * t * t
type t4 = t * t * t * t
type t5 = t * t * t * t * t
