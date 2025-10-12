{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: let
  comp = config.modules.local.system.compositor;
in {
  options.modules.system.programs.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
    hyprlock = lib.mkEnableOption "Enable hyprlock";
  };

  config = lib.mkIf (comp == "hyprland") {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    environment = {
      variables = {
        NIXOS_OZONE_WL = "1";
        GDK_BACKEND = "wayland,x11";
        QT_QPA_PLATFORM = "wayland;xcb";
        XDG_SESSION_TYPE = "wayland";

        # TODO: move this into hidpi option
        GDK_SCALE = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";

        # TODO: move this into theming module
        # theming
        XCURSOR_SIZE = "24";
        XCURSOR_THEME = "Bibata-Modern-Ice";

        MOZ_ENABLE_WAYLAND = "1";
      };
    };
    programs.dconf.enable = true;
  };
}
