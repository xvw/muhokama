module Blocks = struct
  module Assoc = struct
    let kind value = "type", `String value

    let text ?(is_markdown = false) content =
      let kind = if is_markdown then "mrkdwn" else "plain_text" in
      "text", `Assoc [ "type", `String kind; "text", `String content ]
    ;;
  end

  type t =
    | Section of
        { is_markdown : bool
        ; content : string
        }
    | Button of
        { text : string
        ; link : string
        ; value : string
        ; action_id : string
        }
    | Divider

  let section ?(is_markdown = false) content = Section { is_markdown; content }
  let button text link value action_id = Button { text; link; value; action_id }
  let divider = Divider

  let to_yojson : t -> Yojson.Safe.t = function
    | Divider -> `Assoc [ Assoc.kind "divider" ]
    | Section { is_markdown; content } ->
      `Assoc [ Assoc.kind "section"; Assoc.text ~is_markdown content ]
    | Button { text; link; value; action_id } ->
      `Assoc
        [ Assoc.kind "actions"
        ; ( "elements"
          , `List
              [ `Assoc
                  [ Assoc.kind "button"
                  ; Assoc.text text
                  ; "value", `String value
                  ; "action_id", `String action_id
                  ; "url", `String link
                  ]
              ] )
        ]
  ;;

  let from block_list =
    `Assoc [ "blocks", `List (List.map to_yojson block_list) ]
  ;;
end

let webhook_url env =
  let open Lib_common.Env in
  Option.map
    (fun hook_url -> "https://hooks.slack.com/services/" ^ hook_url)
    env.notification_hook
;;

let reach_hook message_content env =
  match webhook_url env with
  | None -> Lwt.return_ok ()
  | Some url ->
    let message = message_content () in
    let open Lib_common.Lwt_util in
    let* _, body = Lib_client.post_json ~data:message url in
    let* () = Cohttp_lwt.Body.drain_body body in
    Lwt.return_ok ()
;;

let new_topic user topic_id topic_title =
  reach_hook (fun () ->
    let username = user.Models.User.name in
    let topic_url = "https://www.muhokama.fun/topic/show/" ^ topic_id in
    Blocks.from
      [ Blocks.section ~is_markdown:true
        @@ Fmt.str "le topic *%s* a été créé par *%s*" topic_title username
      ; Blocks.button "Lire le topic" topic_url "read_topic" "read_topic_0"
      ; Blocks.divider
      ]
    |> Yojson.Safe.to_string)
;;

let new_answer user topic_id topic message_id =
  reach_hook (fun () ->
    let username = user.Models.User.name in
    let topic_url = "https://www.muhokama.fun/topic/show/" ^ topic_id in
    let answer_url = topic_url ^ "#" ^ message_id in
    let topic_title = topic.Models.Topic.Showable.title in
    Blocks.from
      [ Blocks.section ~is_markdown:true
        @@ Fmt.str
             "Une nouvelle réponse dans *%s* par *%s*"
             topic_title
             username
      ; Blocks.button "Lire la réponse" answer_url "read_answer" "read_answer_1"
      ; Blocks.divider
      ]
    |> Yojson.Safe.to_string)
;;
