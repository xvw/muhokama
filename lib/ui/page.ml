open Tyxml

let dummy =
  Template.page
    ~lang:"en"
    ~page_title:"A dummy page"
    Html.[ h1 [ txt "Hello world" ] ]
;;
