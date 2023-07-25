{
  config,
  lib,
  ...
}:
with lib; let
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

  # Workspaces
  ${
    builtins.concatStringsSep "\n" (
      map
      (
        x: let
          monitor =
            if x.monitor != ""
            then ", monitor:${x.monitor}"
            else "";
          default =
            if x.default
            then ", default:true"
            else "";

          gaps_in =
            if x.gaps_in != 0
            then ", gapsin:${x.gaps_in}"
            else "";
          gaps_out =
            if x.gaps_out != 0
            then ", gapsout:${x.gaps_out}"
            else "";
          border_size =
            if x.border_size != 0
            then ", bordersize:${x.border_size}"
            else "";
          border =
            if x.border
            then ", border:true"
            else "";
          rounding =
            if x.rounding
            then ", rounding:true"
            else "";
          decorate =
            if x.decorate
            then ", decorate:true"
            else "";
        in "workspace = ${x.name}${default}${monitor}${gaps_in}${gaps_out}${border_size}${border}${rounding}${decorate}"
      )
      cfg.workspaces
    )
  }

  # Executes
  ${
    builtins.concatStringsSep "\n" (
      map (
        x: let
          exec =
            if x.onReload
            then "exec"
            else "exec-once";
        in "${exec} = ${x.command}"
      )
      cfg.exec
    )
  }

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

    sensitivity = ${cfg.input.sensitivity}
    accel_profile = ${cfg.input.accel_profile}
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
      enabled = ${
    if cfg.animations.enabled
    then "yes"
    else "no"
  }

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

  # Keybinds
  ${
    builtins.concatStringsSep "\n" (
      map
      (
        x:
          if x.mouseBind
          then "bindm = ${x.modifier}, ${x.key}, ${x.keyword}"
          else "bind = ${x.modifier}, ${x.key}, ${x.keyword}, ${x.command}"
      )
      cfg.keybinds.binds
    )
  }


  # Nvidia
  ${
    if (config.modules.system.nvidia)
    then ''
      env = WLR_NO_HARDWARE_CURSORS,1
    ''
    else ""
  }
''
