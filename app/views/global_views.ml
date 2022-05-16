let error ?flash_info ?user () =
  Templates.Layout.default
    ~lang:"fr"
    ~page_title:"Une erreur est survenue"
    ?flash_info
    ?user
    []
;;
