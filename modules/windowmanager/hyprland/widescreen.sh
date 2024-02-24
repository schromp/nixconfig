#!/usr/bin/env bash

default_gaps=15

change_gaps() {
  local amount="$(hyprctl activeworkspace -j | jq '.["windows"]')"
  
  if [ "$amount" -eq 1 ]; then
    echo One window
    hyprctl keyword general:gaps_out $default_gaps, 350 >/dev/null

  else
    echo More windows
    hyprctl keyword general:gaps_out $default_gaps >/dev/null
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
