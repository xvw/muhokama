let hello_world ?flash_info ?user () =
  Templates.Layout.default
    ~lang:"en"
    ~page_title:"Hello World!"
    ?user
    ?flash_info
    Tyxml.Html.[ txt "Hello World!" ]
;;
