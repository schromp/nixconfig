{
  config,
  lib,
  pkgs,
  sysConfig,
  ...
}: let
  cfg = config.modules.home.programs.hyprland;
  appRunner = config.modules.home.general.desktop.defaultAppRunner;
  browser = config.modules.home.general.desktop.defaultBrowser;
  screenshotTool = config.modules.home.general.desktop.defaultScreenshotTool;
  monitors = sysConfig.monitors;
  keymap_language =
    if (sysConfig.keymap == "us-umlaute")
    then ''
      us-german-umlaut
    ''
    else ''
      us
    '';
  widescreenScript = pkgs.writeShellScript "widescreen_gaps" (builtins.readFile ./widescreen.sh);
in {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    # monitor = [ "DP-3,3440x1440@144,0x0,1" ];

    monitor = lib.lists.forEach monitors (monitor: "${monitor.name},${monitor.resolution}@${monitor.refreshRate},${monitor.position},${monitor.scale},${
      if monitor.vrr
      then "vrr,1"
      else ""
    }");

    # # TODO: make this universal
    # workspace = mkIf (lists.count monitors != 1) [
    #   "r[1-5],${(builtins.elemAt monitors 0).name}"
    #   "r[6-9],${(builtins.elemAt monitors 1).name}"
    # ];

    exec-once = [
      "${lib.getExe pkgs.swww} init & ${lib.getExe pkgs.swww} img /home/lk/Documents/Wallpapers/wallpaper.png"
      (
        if appRunner == "walker"
        then ''"walker gapplication-service"''
        else ""
      )
      "${widescreenScript}"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # screenshare"
      "exec-once = wl-paste -p --watch wl-copy -pc # disables middle click paste"
      "ags"
      "hyprctl setcursor Bibata-Modern-Ice 24"
      "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service" # FIX: xdg open doesnt work without this
      "${lib.getExe pkgs.lxqt.lxqt-policykit}"
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

      # device = {
      #   "kensington-orbit-fusion-wireless-trackball-1" = {
      #     sensitivity = "-0.5";
      #   };
      # };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_distance = 200;
    };

    animations = {
      enabled = true;
      animation = [
        (
          if cfg.workspace_animations
          then "workspaces,1,3,default,slidevert"
          else "workspaces,0"
        )
      ];
    };

    general = {
      gaps_in = 8;
      gaps_out = 8;
      border_size = 2;
      layout = "dwindle";

      allow_tearing = false;

      # WARN: TEMP
      "col.active_border" = "rgb(44475a) rgb(bd93f9) 90deg";
      "col.inactive_border" = "rgba(44475aaa)";
    };

    dwindle = {
      # default_split_ratio = 0.7;
      # force_split = 1; # always split to left/top
    };

    misc = {
      force_default_wallpaper = 0;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      animate_manual_resizes = true;
      initial_workspace_tracking = 2;
    };

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    # WARN: This is temporary until themer-rs is functional
    decoration = {
      rounding = 10;
      "col.shadow" = "rgba(1E202966)";
    };

    bind =
      [
        "$mod, Q, killactive"
        "$mod CONTROL, M, exit"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, P, pin"
        "$mod, O, pseudo"
        (
          if cfg.hyprlock.enable
          then "$mod CONTROL, L, exec, hyprlock"
          else ""
        )

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$mod SHIFT, h, swapwindow, l"
        "$mod SHIFT, j, swapwindow, d"
        "$mod SHIFT, k, swapwindow, u"
        "$mod SHIFT, l, swapwindow, r"

        "$mod CONTROL, 1, movecurrentworkspacetomonitor, 0"
        "$mod CONTROL, 2, movecurrentworkspacetomonitor, 1"

        "$mod, 36, exec, rio"
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
        "$mod SHIFT, P, exec, ${lib.getExe pkgs.hyprpicker} -a"

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
          ''$mod, R, exec, ${lib.getExe config.modules.programs.tofi.runnerScript}''
          # ''$mod, R, exec, tofi-drun --drun-launch=true''
          # ''$mod SHIFT, F, exec, hyprctl clients -j | jq -r '.[] | select(.initialClass != " " and .pid != -1) | .initialClass' | tofi | xargs -r hyprctl dispatch focuswindow --''
        ]
        else ["$mod, R, exec, ${appRunner}"] # WARN: problematic because of different executable names
      );
  };
}
