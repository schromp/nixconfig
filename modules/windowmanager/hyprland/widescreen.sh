#!/usr/bin/env bash

default_gaps=7

gcd() {
  if [[ $2 -eq 0 ]]; then
    echo "$1"
  else
    gcd "$2" "$(($1 % $2))"
  fi
}

change_gaps() {
  local monitor=$(hyprctl monitors -j)
  local monitor_width=$(echo $monitor | jq '.[] | .["width"]')
  local monitor_height=$(echo $monitor | jq '.[] | .["height"]')

  local gcd=$(gcd "$monitor_width" "$monitor_height")

  local aspect_ratio="$((monitor_width / gcd)):$((monitor_height / gcd))"

  if [ "$aspect_ratio" = "43:18" ]; then
    local workspace_id=$(hyprctl activeworkspace -j | jq '.["id"]')
    local amount=$(hyprctl clients -j | jq --argjson workspace_id "$workspace_id" '[ .[] | select(.workspace.id == $workspace_id and .floating == false and .pid != -1 and .hidden == false)] | length')
    
    if [ "$amount" -eq 1 ]; then
      hyprctl keyword workspace $workspace_id,gapsout:$default_gaps 350 # >/dev/null
    else
      hyprctl keyword workspace $workspace_id,gapsout:$default_gaps # >/dev/null
    fi
  fi

}

handle() {
  case $1 in
    openwindow*) change_gaps ;;
    closewindow*) change_gaps ;;
    workspace*) change_gaps ;;
  esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
