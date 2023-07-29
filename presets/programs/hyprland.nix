{
  config,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.presets.programs;
  appRunner = config.modules.user.appRunner;
  keymap_language =
    if (config.modules.user.keymap == "us-umlaute")
    then ''
      us-german-umlaut
    ''
    else ''
      us
    '';
in {
  config = mkIf (builtins.elem "hyprland" cfg) {
    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings = {
        "$mod" = "SUPER";

        exec-once = [
          "swww init & swww img /home/lk/Pictures/Wallpaper/od_outrun_wave.png"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # screenshare"
          "exec-once = wl-paste -p --watch wl-copy -pc # disables middle click paste"
        ];

        input = {
          kb_layout = keymap_language; # TODO: not pretty
          follow_mouse = 2;
          touchpad = {
            natural_scroll = true;
          };

          sensitivity = "-0.2";
          accel_profile = "flat";
        };

        animations.enabled = false;

        general = {
          gaps_in = 3;
          gaps_out = 7;
          border_size = 2;
          layout = "dwindle";
        };

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        bind = [
          "$mod, Q, killactive"
          "$mod CONTROL, M, exit"
          "$mod, V, togglefloating"
          "$mod, P, pseudo"
          "$mod, F, fullscreen"

          "$mod, h, movefocus, l"
          "$mod, j, movefocus, u"
          "$mod, k, movefocus, d"
          "$mod, l, movefocus, r"

          "$mod, 36, exec, kitty"
          "$mod, B, exec, firefox"
          "$mod, R, exec, ${appRunner}" # WARN: problematic because of different exe names
          "$mod SHIFT, S, exec, grimblast copy area"

          "${builtins.concatStringsSep "\n" (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in ''
                bind = $mod, ${ws}, workspace, ${toString (x + 1)}
                bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
              ''
            )
            10)}"
        ];
      };
    };
  };
}
