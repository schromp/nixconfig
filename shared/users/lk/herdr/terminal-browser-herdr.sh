# terminal-browser's terminal API (TERMINAL_BROWSER_TERMINAL_SOCKET) for the Herdr app.
# socat runs this once per connection: one JSON request line in, one reply line out.
# Panes are herdr-core terminal addresses (t3), tabs are Herdr tab ids.
# Protocol: https://github.com/zenbu-labs/terminal-browser#implementing-the-api-in-your-terminal

state=${XDG_RUNTIME_DIR:-/tmp}/terminal-browser-herdr
neighbors=$state/neighbors

IFS= read -r line || exit 0
id=$(jq -r '.id // ""' <<<"$line")
method=$(jq -r '.method // ""' <<<"$line")
params=$(jq -c '.params // {}' <<<"$line")
caller_pid=$(jq -r '.caller.pid // ""' <<<"$line")
caller_cwd=$(jq -r '.caller.cwd // ""' <<<"$line")

ok() {
  jq -cn --arg id "$id" --argjson r "$1" '{id: $id, result: $r}'
  exit 0
}
fail() {
  jq -cn --arg id "$id" --arg m "$1" '{id: $id, error: {message: $m}}'
  exit 0
}
param() { jq -r "$1 // \"\"" <<<"$params"; }

# `herdr-app do` into $out, failing the request with its error.
# Never call fail-capable functions inside $(...): fail has to exit this shell.
app() {
  if ! out=$(herdr-app "do" "$1" "$2" 2>&1); then
    fail "herdr-app $1: $(jq -r '.error // empty' <<<"$out" 2>/dev/null || echo "$out")"
  fi
}

# The herdr-core terminal a process runs in: the nearest HC_TERMINAL_ID up its ancestry
# (agents' tool shells often drop it from their own environment).
terminal_of_pid() {
  local pid=$1 t
  while [ -n "$pid" ] && [ "$pid" -gt 1 ]; do
    t=$(tr '\0' '\n' <"/proc/$pid/environ" 2>/dev/null | sed -n 's/^HC_TERMINAL_ID=//p' | head -n1)
    if [ -n "$t" ]; then
      echo "$t"
      return
    fi
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  done
}

ls_json=
case $method in
getCurrentPane | listPanes | split | neighbor)
  ls_json=$(herdr-app ls) || fail "herdr-app ls failed (is the app open?)"
  ;;
esac
tab_of() { jq -r --arg t "$1" 'first(.spaces[].tabs[] | select(any(.terminals[]; .terminal == $t)) | .id) // ""' <<<"$ls_json"; }
pane_of() { jq -r --arg t "$1" 'first(.spaces[].tabs[].terminals[] | select(.terminal == $t) | .pane) // ""' <<<"$ls_json"; }
pane_json() {
  local tab
  tab=$(tab_of "$1")
  if [ -n "$tab" ]; then jq -cn --arg id "$1" --arg tab "$tab" '{id: $id, tab: $tab}'; else echo null; fi
}

case $method in
hello)
  ok '{"name": "herdr-app", "methods": ["getCurrentPane", "split", "listPanes", "neighbor", "sendText", "pasteKey", "focusPane"]}'
  ;;

getCurrentPane)
  t=$(terminal_of_pid "$caller_pid")
  [ -n "$t" ] || ok '{"pane": null}'
  ok "{\"pane\": $(pane_json "$t")}"
  ;;

listPanes)
  # every pane of the caller's space, like terminal-browser's herdr TUI backend lists its workspace
  t=$(terminal_of_pid "$caller_pid")
  [ -n "$t" ] || ok '{"panes": []}'
  rows=$(jq -r --arg t "$t" '.spaces[] | select(any(.tabs[].terminals[]; .terminal == $t))
    | .tabs[] | .id as $tab | .terminals[] | "\(.terminal)\t\($tab)"' <<<"$ls_json")
  panes='[]'
  while IFS=$'\t' read -r term tab; do
    [ -n "$term" ] || continue
    info=$(hc get "$term" --json </dev/null 2>/dev/null) || continue
    pid=$(jq -r '.pid // ""' <<<"$info")
    tty=
    [ -n "$pid" ] && tty=$(readlink "/proc/$pid/fd/0" 2>/dev/null)
    case $tty in /dev/pts/*) ;; *) tty= ;; esac
    panes=$(jq -c --arg id "$term" --arg tab "$tab" --arg tty "$tty" --argjson info "$info" \
      '. + [{id: $id, tab: $tab, tty: (if $tty == "" then null else $tty end),
             command: ($info.foreground.argv // null | if . then join(" ") else null end)}]' <<<"$panes")
  done <<<"$rows"
  ok "{\"panes\": $panes}"
  ;;

split)
  from=$(param .from.id)
  direction=$(param .direction)
  pane=$(pane_of "$from")
  [ -n "$pane" ] || fail "no Herdr pane shows terminal $from"
  case $direction in
  right | left) native=right ;;
  down | up) native=down ;;
  *) fail "unknown direction $direction" ;;
  esac
  # start in the caller's folder, and keep this adapter for the new pane's terminal-browser
  argv=$(jq -c --arg cwd "$caller_cwd" --arg sock "${TERMINAL_BROWSER_TERMINAL_SOCKET:-}" \
    '["env", "TERMINAL_BROWSER_TERMINAL_SOCKET=\($sock)", "sh", "-c", "cd \"$1\" 2>/dev/null; shift; exec \"$@\"", "sh", $cwd] + .command' <<<"$params")
  app pane.split "$(jq -cn --arg d "$native" --arg p "$pane" --argjson a "$argv" '{direction: $d, pane: $p, argv: $a}')"
  new_pane=$(jq -r .pane <<<"$out")
  new_term=$(jq -r .terminal <<<"$out")
  # Herdr only splits right/down: move the new pane to the other side
  if [ "$direction" = left ] || [ "$direction" = up ]; then
    app pane.swap "$(jq -cn --arg p "$new_pane" --arg d "$direction" '{pane: $p, direction: $d}')"
  fi
  mkdir -p "$state"
  printf '%s %s %s\n' "$from" "$direction" "$new_term" >>"$neighbors"
  ok '{}'
  ;;

neighbor)
  # Herdr exposes no pane geometry, so remember the splits made here: enough to reuse
  # the browser opened beside a pane instead of splitting again.
  from=$(param .from.id)
  direction=$(param .direction)
  if [ -f "$neighbors" ]; then
    while read -r f d n; do
      [ "$f" = "$from" ] && [ "$d" = "$direction" ] || continue
      p=$(pane_json "$n")
      [ "$p" != null ] && ok "{\"pane\": $p}"
    done < <(tac "$neighbors")
  fi
  ok '{"pane": null}'
  ;;

sendText)
  # hc only pastes followed by Enter, so paste through the app instead:
  # clipboard, focus, terminal.paste, then put the clipboard back
  term=$(param .pane)
  text=$(param .text)
  saved=$(mktemp)
  type=$(wl-paste --list-types 2>/dev/null | head -n1)
  [ -n "$type" ] && wl-paste --no-newline --type "$type" >"$saved" 2>/dev/null
  printf '%s' "$text" | wl-copy
  app pane.focus "$(jq -cn --arg t "$term" '{terminal: $t}')"
  app terminal.paste '{}'
  sleep 0.3
  if [ -n "$type" ]; then wl-copy --type "$type" <"$saved"; else wl-copy --clear; fi
  rm -f "$saved"
  ok '{}'
  ;;

pasteKey)
  hc keys "$(param .pane)" ctrl+v </dev/null >/dev/null 2>&1 || fail "hc keys failed"
  ok '{}'
  ;;

focusPane)
  app pane.focus "$(jq -cn --arg t "$(param .pane)" '{terminal: $t}')"
  ok '{}'
  ;;

*)
  fail "unknown method $method"
  ;;
esac
