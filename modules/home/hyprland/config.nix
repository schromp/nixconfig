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
  terminal = config.modules.home.general.desktop.defaultTerminal;
  monitors = sysConfig.modules.system.general.monitors;
  keymap_language =
    if (config.modules.home.general.keymap == "us-umlaute")
    then ''
      us-german-umlaut
    ''
    else ''
      us
    '';
in {

  wayland.windowManager.hyprland.settings = {
    source = [
      "~/.config/hypr/theme.conf"
    ];

    "$mod" = "SUPER";

    monitor = lib.lists.forEach monitors (monitor: "${monitor.name},${monitor.resolution}@${monitor.refreshRate},${monitor.position},${monitor.scale},bitdepth, 8,${
        if monitor.vrr
        then "vrr,1,"
        else ""
      }${
        if monitor.transform != ""
        then "transform,${monitor.transform},"
        else ""
      }");

    workspace = lib.mkIf (lib.lists.count monitors != 1) [
      "1, monitor:${(builtins.elemAt monitors 0).name}, default:true"
      "2, monitor:${(builtins.elemAt monitors 0).name}"
      "3, monitor:${(builtins.elemAt monitors 0).name}"
      "4, monitor:${(builtins.elemAt monitors 0).name}"
      "5, monitor:${(builtins.elemAt monitors 0).name}"
      "6, monitor:${(builtins.elemAt monitors 0).name}"
      "7, monitor:${(builtins.elemAt monitors 1).name}"
      "8, monitor:${(builtins.elemAt monitors 1).name}"
      "9, monitor:${(builtins.elemAt monitors 1).name}, default:true"
      "w[t1]m[DP-3], gapsout:10 400 10 400"
    ];

    exec-once = [
      "${pkgs.swww}/bin/swww-daemon"
      "${lib.getExe pkgs.pa_applet}"
      "exec-once = wl-paste -p --watch wl-copy -pc # disables middle click paste"
      "hyprctl setcursor Bibata-Modern-Ice 24"
      "${lib.getExe pkgs.lxqt.lxqt-policykit}"
      "[workspace special:yazi silent; float] kitty -e yazi"
    ];

    windowrulev2 = [
      "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
      "noanim,class:^(xwaylandvideobridge)$"
      "nofocus,class:^(xwaylandvideobridge)$"
      "noinitialfocus,class:^(xwaylandvideobridge)$"
      "nofocus, class:^(steam)$, title:^()$"
      "immediate, class:^(overwatch)$"
      "float, class:steam_app_3411730"
      "noblur, class:steam_app_3411730"
      "nofocus, class:steam_app_3411730"
      "noshadow, class:steam_app_3411730"
      "noborder, class:steam_app_3411730"
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
        (
          if cfg.workspace_animations
          then "workspaces,1,3,default,slidevert"
          else "workspaces,0"
        )
      ];
    };

    general = {
      allow_tearing = false;
    };

    misc = {
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      animate_manual_resizes = true;
      initial_workspace_tracking = 0;
      middle_click_paste = false;
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
        "$mod, O, pseudo"
        "$mod, SPACE, exec, vicinae toggle"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$mod SHIFT, h, swapwindow, l"
        "$mod SHIFT, j, swapwindow, d"
        "$mod SHIFT, k, swapwindow, u"
        "$mod SHIFT, l, swapwindow, r"

        "$mod CONTROL, h, resizeactive, -75 0"
        "$mod CONTROL, j, resizeactive, 0 75"
        "$mod CONTROL, k, resizeactive, 0 -75"
        "$mod CONTROL, l, resizeactive, 75 0"

        "$mod CONTROL, 1, movecurrentworkspacetomonitor, 0"
        "$mod CONTROL, 2, movecurrentworkspacetomonitor, 1"

        "$mod, 36, exec, ${terminal}"
        "$mod, B, exec, ${browser}"
        (
          if screenshotTool == "grimblast"
          then "$mod SHIFT, S, exec, grimblast copy area"
          else if screenshotTool == "satty"
          then ''$mod SHIFT, S, exec, grim -g "$(slurp -o -r -c '#ff0000ff')" - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png''
          else if screenshotTool == "swappy"
          then ''$mod SHIFT, S, exec, grim -g "$(slurp)" - | ${lib.getExe pkgs.swappy} -f -''
          else ""
        )
        ''$mod CONTROL, S, exec, ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" - | ${lib.getExe pkgs.tesseract} stdin - | wl-copy''
        "$mod SHIFT, P, exec, ${lib.getExe pkgs.hyprpicker} -a"

        ", XF86MonBrightnessUp, exec, brightnessctl s +10"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10-"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        "CONTROL, F12, pass, class:^(com\.obsproject\.Studio)$"
        "CONTROL, HOME, pass, class:^(discord)$"
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
        10));
  };
}
