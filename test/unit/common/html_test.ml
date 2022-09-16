open Lib_common
open Lib_test

let test_escape_special_char_without_special_char =
  test
    ~about:"escape_special_chars"
    ~desc:"when there is not special chars, it should preserve the string"
    (fun () ->
    let subject =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce \
       tristique commodo auctor. Nam faucibus ultrices pulvinar. Aenean \
       vehicula massa velit, at euismod dui sollicitudin et. Integer et orci \
       tempor, eleifend felis et, ultricies lorem. Quisque dictum nunc \
       malesuada metus convallis, a efficitur ex lacinia. Nam sit amet \
       accumsan eros. Nulla rhoncus massa id enim egestas, ac venenatis augue \
       molestie. Morbi ultrices eget augue vitae ultrices. Mauris tempus justo \
       et nisi malesuada, in maximus metus ultricies. Proin quis erat quis \
       lectus aliquet gravida. Maecenas mattis sit amet lacus sed vulputate. \
       Ut mollis nibh arcu, ac vestibulum orci ullamcorper eu. Donec a \
       lobortis ante. Orci varius natoque penatibus et magnis dis parturient \
       montes, nascetur ridiculus mus."
    in
    let expected = subject
    and computed = Html.escape_special_chars subject in
    same Alcotest.string ~expected ~computed)
;;

let test_escape_special_char_with_chars =
  test
    ~about:"escape_special_chars"
    ~desc:"when there is not special chars, it should preserve the string"
    (fun () ->
    let subject =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce \
       <strong>tristique commodo auctor. Nam faucibus ultrices pulvinar. \
       </strong>Aenean vehicula massa velit, <i>at euismod 'dui sollicitudin \
       e'</i>t. Integer et \"orci tempor, eleifend felis\" et, ultricies \
       lorem. Quisque dictum nunc malesuada metus convallis, a efficitur ex \
       lacinia. Nam sit amet accumsan eros. Nulla rhoncus massa id enim \
       egestas, ac venenatis augue molestie. Morbi ultrices eget augue vitae \
       ultrices. Mauris tempus justo et nisi malesuada, in maximus metus \
       ultricies. Proin quis erat quis lectus aliquet gravida. Maecenas mattis \
       sit amet lacus sed vulputate. Ut mollis nibh arcu, ac vestibulum orci \
       ullamcorper eu. Donec a lobortis ante. Orci varius natoque penatibus et \
       magnis dis parturient montes, nascetur ridiculus mus."
    in
    let expected =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce \
       &lt;strong&gt;tristique commodo auctor. Nam faucibus ultrices pulvinar. \
       &lt;/strong&gt;Aenean vehicula massa velit, &lt;i&gt;at euismod \
       &apos;dui sollicitudin e&apos;&lt;/i&gt;t. Integer et &quot;orci \
       tempor, eleifend felis&quot; et, ultricies lorem. Quisque dictum nunc \
       malesuada metus convallis, a efficitur ex lacinia. Nam sit amet \
       accumsan eros. Nulla rhoncus massa id enim egestas, ac venenatis augue \
       molestie. Morbi ultrices eget augue vitae ultrices. Mauris tempus justo \
       et nisi malesuada, in maximus metus ultricies. Proin quis erat quis \
       lectus aliquet gravida. Maecenas mattis sit amet lacus sed vulputate. \
       Ut mollis nibh arcu, ac vestibulum orci ullamcorper eu. Donec a \
       lobortis ante. Orci varius natoque penatibus et magnis dis parturient \
       montes, nascetur ridiculus mus."
    and computed = Html.escape_special_chars subject in
    same Alcotest.string ~expected ~computed)
;;

let cases =
  ( "Html"
  , [ test_escape_special_char_without_special_char
    ; test_escape_special_char_with_chars
    ] )
;;
