let hello_world ?flash_info () =
  Template.Layout.default
    ~lang:"en"
    ~page_title:"Hello World!"
    ?flash_info
    Tyxml.Html.[ txt "Hello World!" ]
;;
