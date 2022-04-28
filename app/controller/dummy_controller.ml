open Util

let hello_world user request =
  let flash_info = Service.Flash_info.fetch request in
  let view = View.Dummy.hello_world ?flash_info ~user () in
  Dream.html @@ from_tyxml view
;;
