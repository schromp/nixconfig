#!/usr/bin/env bash

default_gaps=15

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
    local amount="$(hyprctl clients -j | jq '[ .[] | select(.workspace.id == 1 and .floating == false and .pid != -1 and .hidden == false)] | length')"
    
    if [ "$amount" -eq 1 ]; then
      hyprctl keyword general:gaps_out $default_gaps, 350 >/dev/null
    else
      hyprctl keyword general:gaps_out $default_gaps >/dev/null
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
