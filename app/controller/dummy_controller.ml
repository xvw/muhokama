open Util

let hello_world request =
  let flash_info = Flash_info.fetch request in
  let view = View.Dummy.hello_world ?flash_info () in
  Dream.html @@ from_tyxml view
;;
