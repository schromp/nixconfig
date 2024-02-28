{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.hyprland;
  username = config.modules.user.username;
  appRunner = config.modules.user.appRunner;
  browser = config.modules.user.browser;
  screenshotTool = config.modules.user.screenshotTool;
  monitor = config.modules.user.monitor;
  keymap_language =
    if (config.modules.user.keymap == "us-umlaute")
    then ''
      us-german-umlaut
    ''
    else ''
      us
    '';
  widescreenScript = pkgs.writeShellScript "widescreen_gaps" (builtins.readFile ./widescreen.sh);

  colors = config.presets.themes.colors;
  focused = colors.base0C;
  unfocused = colors.base03;
in {
  home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    # monitor = [ "DP-3,3440x1440@144,0x0,1" ];

    monitor = ["${monitor.name},${monitor.resolution}@${monitor.refreshRate},${monitor.position},${monitor.scale}"];

    exec-once = [
      # "swww init & swww img /home/lk/Documents/Wallpapers/wallpaper.png"
      "${widescreenScript}"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # screenshare"
      "exec-once = wl-paste -p --watch wl-copy -pc # disables middle click paste"
      "ags"
      "hyprctl setcursor ${config.presets.themes.cursor.name} 24"
      "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service" # FIX: xdg open doesnt work without this
    ];

    windowrulev2 = [
      "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
      "noanim,class:^(xwaylandvideobridge)$"
      "nofocus,class:^(xwaylandvideobridge)$"
      "noinitialfocus,class:^(xwaylandvideobridge)$"
      "nofocus, class:^(steam)$, title:^()$"
      "immediate, class:^(overwatch)$"
    ];

    input = {
      kb_layout = "${keymap_language}"; # TODO: not pretty
      follow_mouse = 2;
      mouse_refocus = false;
      touchpad = {
        natural_scroll = true;
      };

      sensitivity = cfg.sens;
      accel_profile = cfg.accel;

      touchpad = {
        scroll_factor = 0.5;
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_distance = 200;
    };

    animations = {
      enabled = true;
      animation = [
        "workspaces,1,3,default,slidevert"
      ];
    };

    general = {
      gaps_in = 7;
      gaps_out = 7;
      border_size = 2;
      layout = "dwindle";

      allow_tearing = true;

      "col.active_border" = "rgb(c678dd) rgb(${focused})";
      "col.inactive_border" = "rgb(${unfocused})";
    };

    dwindle = {
      default_split_ratio = 0.7;
      force_split = 1; # always split to left/top
    };

    misc = {
      force_default_wallpaper = 0;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      animate_manual_resizes = true;
    };

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bind =
      [
        "$mod, Q, killactive"
        "$mod CONTROL, M, exit"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, P, pin"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$mod SHIFT, h, swapwindow, l"
        "$mod SHIFT, j, swapwindow, d"
        "$mod SHIFT, k, swapwindow, u"
        "$mod SHIFT, l, swapwindow, r"

        "$mod, 36, exec, kitty"
        "$mod, B, exec, ${lib.getExe pkgs.${browser}}"
        (
          if screenshotTool == "grimblast"
          then "$mod SHIFT, S, exec, grimblast copy area"
          else if screenshotTool == "satty"
          then ''$mod SHIFT, S, exec, grim -g "$(slurp -o -r -c '#ff0000ff')" - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png''
          else if screenshotTool == "swappy"
          then ''$mod SHIFT, S, exec, grim -g "$(slurp)" - | ${lib.getExe pkgs.swappy} -f -''
          else ""
        )

        "$mod A, A, exec, systemctl --user restart ags"

        "$mod SHIFT, Z, exec, hyprctl keyword misc:cursor_zoom_factor, 2"

        ", XF86MonBrightnessUp, exec, brightnessctl s +10"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10-"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ]
      ++ (lib.lists.flatten (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            ''$mod, ${ws}, workspace, ${toString (x + 1)}''
            ''$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)} ''
          ]
        )
        10))
      ++ (
        if appRunner == "tofi"
        then [
          ''$mod, R, exec, tofi-drun --drun-launch=true''
          ''$mod SHIFT, F, exec, hyprctl clients -j | jq -r '.[] | select(.initialClass != " " and .pid != -1) | .initialClass' | tofi | xargs -r hyprctl dispatch focuswindow --''
        ]
        else ["$mod, R, exec, ${appRunner}"] # WARN: problematic because of different executable names
      );
  };
}
