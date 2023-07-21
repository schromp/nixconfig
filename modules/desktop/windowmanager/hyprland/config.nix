{
  config,
  lib,
  ...
}:
with lib; let
  # FIX: config.modules isn't reachable here for some reason
  inherit config;
  cfg = config.modules.programs.hyprland.config;
  keymap_language =
    if (config.modules.user.keymap == "us-umlaute")
    then ''
      us-german-umlaut
    ''
    else ''
      us
    '';
in ''
  monitor=DP-3,1920x1080@144,320x1080,1
  monitor=HDMI-A-1,2560x1080@75,0x0,1,transform,2

  workspace = 1, monitor:DP-3, default:true
  workspace = 2, monitor:DP-3, default:false
  workspace = 3, monitor:DP-3, default:false
  workspace = 4, monitor:DP-3, default:false
  workspace = 5, monitor:DP-3, default:false
  workspace = 6, monitor:HDMI-A-1, default:true
  workspace = 7, monitor:HDMI-A-1, default:false
  workspace = 8, monitor:HDMI-A-1, default:false
  workspace = 9, monitor:HDMI-A-1, default:false
  workspace = 10, monitor:HDMI-A-1, default:false


  exec-once = eww daemon
  exec-once = eww open bar
  exec-once = swww init & swww img /home/lk/Pictures/Wallpaper/od_outrun_wave.png
  exec-once = wl-paste -p --watch wl-copy -pc # disables middle click paste
  exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # screenshare

  input {
    kb_layout = ${keymap_language}

    follow_mouse = 2

    touchpad {
        natural_scroll = yes
        scroll_factor = 0.5
        disable_while_typing = true
        drag_lock = true
    }

    sensitivity = -0.2 # -1.0 - 1.0, 0 means no modification.
    accel_profile = flat
  }


  general {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      gaps_in = ${toString cfg.general.gaps_in}
      gaps_out = ${toString cfg.general.gaps_out}
      border_size = ${toString cfg.general.border_size}
      col.active_border = rgba(${cfg.general.col_active_border})
      col.inactive_border = rgba(${cfg.general.col_inactive_border})

      layout = dwindle
  }


  animations {
      enabled = ${cfg.animations.enabled}

      # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

      bezier = myBezier, 0.05, 0.9, 0.1, 1.05

      animation = windows, 1, 7, myBezier
      animation = windowsOut, 1, 7, default, slide
      animation = windowsIn, 1, 6, default, slide
      animation = border, 1, 10, default
      animation = fade, 0, 7, default
      animation = workspaces, 1, 6, default, slide
  }

  gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = on
    workspace_swipe_fingers = 4
  }
  dwindle {
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = yes # you probably want this
  }


  $mainMod = ${cfg.keybinds.mainMod}

  ${
    # WARN: untested
    builtins.concatStringsSep "\n" (
      map
      # (x: "${if x.mouseBind then "bindm" else "bind"} = ${x.modifier}, ${x.key}, ${x.keyword}, ${x.command}")
      (x: if x.mouseBind then
        "bindm = ${x.modifier}, ${x.key}, ${x.keyword}"
      else
        "bind = ${x.modifier}, ${x.key}, ${x.keyword}, ${x.command}"
      )
      cfg.keybinds.binds
    )
  }

  # Switch workspaces with mainMod + [0-9]
  bind = $mainMod, 1, workspace, 1
  bind = $mainMod, 2, workspace, 2
  bind = $mainMod, 3, workspace, 3
  bind = $mainMod, 4, workspace, 4
  bind = $mainMod, 5, workspace, 5
  bind = $mainMod, 6, workspace, 6
  bind = $mainMod, 7, workspace, 7
  bind = $mainMod, 8, workspace, 8
  bind = $mainMod, 9, workspace, 9
  bind = $mainMod, 0, workspace, 10

  # Move active window to a workspace with mainMod + SHIFT + [0-9]
  bind = $mainMod SHIFT, 1, movetoworkspace, 1
  bind = $mainMod SHIFT, 2, movetoworkspace, 2
  bind = $mainMod SHIFT, 3, movetoworkspace, 3
  bind = $mainMod SHIFT, 4, movetoworkspace, 4
  bind = $mainMod SHIFT, 5, movetoworkspace, 5
  bind = $mainMod SHIFT, 6, movetoworkspace, 6
  bind = $mainMod SHIFT, 7, movetoworkspace, 7
  bind = $mainMod SHIFT, 8, movetoworkspace, 8
  bind = $mainMod SHIFT, 9, movetoworkspace, 9
  bind = $mainMod SHIFT, 0, movetoworkspace, 10

  ${
    if (config.modules.system.nvidia)
    then ''
      env = WLR_NO_HARDWARE_CURSORS,1
    ''
    else ""
  }

  ${
    # TODO: fuzzel stuff
    if (config.modules.user.appRunner == "fuzzel")
    then ''
    ''
    else ""
  }
''
