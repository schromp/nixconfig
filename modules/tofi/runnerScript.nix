{
  pkgs,
  lib,
  ...
}: let
  jq = lib.getExe pkgs.jq;
  tofi = "${pkgs.tofi}/bin/tofi";
  tofiDrun = "${pkgs.tofi}/bin/tofi-drun";
  bw = lib.getExe pkgs.bitwarden-cli;
in
  pkgs.writeShellScriptBin "tofiRunnerScript" ''
    #!/usr/bin/env bash

    generateOptions() {
      # System options
      echo "shutdown"
      echo "reboot"
      echo "suspend"
      echo "lock"

      echo "rr"
      echo "fw"
      echo "bw"
    }

    confirmSelection() {
        selection=$(echo -e "yes\nno" | ${tofi})
        if [ "$selection" = "yes" ]; then
          # systemctl suspend
          $1
        elif [ "$selection" = "no" ]; then
          echo "no"
          exit 0
        fi
    }

    SESSION_FILE="$HOME/.bitwarden-session"

    unlock() {
      password=$(echo "" | ${tofi} --hide-input=true --hidden-character="*" --prompt="Password:" --num-results=1 --require-match=false)
      response=$(${bw} unlock --nointeraction --response $password)
      success=$(echo $response | ${jq} -r '.success')

      if [ "$success" = "false" ]; then
        echo "Failed to unlock Bitwarden"
        exit 1
      fi

      key=$(echo $response | ${jq} -r '.data.raw')
      echo "$key"
    }

    bitwarden() {
      if [ -s "$SESSION_FILE" ]; then
          SESSION_KEY=$(<"$SESSION_FILE")
      else
          # If session file doesn't exist or is empty, unlock Bitwarden and save the session key
          SESSION_KEY=$(unlock)
          if [ $? -ne 0 ]; then
            echo "Failed to unlock Bitwarden"
            exit 1
          fi
          echo "$SESSION_KEY" > "$SESSION_FILE"
      fi

      items=$(${bw} list items --nointeraction --session $SESSION_KEY)

      # If session key is invalid, unlock Bitwarden and save the session key
      if [ $? -ne 0 ]; then
        SESSION_KEY=$(unlock)
        if [ $? -ne 0 ]; then
          echo "Failed to unlock Bitwarden"
          exit 1
        fi

        echo "$SESSION_KEY" > "$SESSION_FILE"
        items=$(${bw} list items --nointeraction --session $SESSION_KEY)
      fi

      selected=$(echo "$items" | ${jq} -r '.[] | .name' | ${tofi} --)

      if [ -z "$selected" ]; then
        echo "No item selected"
        exit 1
      fi

      selected_id=$(echo "$items" | ${jq} -r ".[] | select(.name == \"$selected\") | .id")
      ${bw} get item $selected_id --session $SESSION_KEY | ${jq} -r '.login.password' | wl-copy
    }

    mode=$(generateOptions | ${tofi} --prompt="cmd:")

    case $mode in
      poweroff)
        confirmSelection "poweroff"
        ;;
      reboot)
        confirmSelection "reboot"
        ;;
      suspend)
        confirmSelection "systemctl suspend"
        ;;
      lock)
        hyprlock
        ;;
      rr)
        ${tofiDrun} --drun-launch=true
        ;;
      fw)
        clients=$(hyprctl clients -j | ${jq} -r '.[] | select(.initialClass != " " and .pid != -1) | .initialClass')
        printf '%s\n' "$clients" | ${tofi} | xargs -r hyprctl dispatch focuswindow --
        ;;
      bw)
        bitwarden
        ;;
      *)
        echo "Invalid option"
        ;;
    esac
  ''
