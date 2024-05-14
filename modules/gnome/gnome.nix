{
  lib,
  config,
  ...
}: let
  # username = config.modules.username;
  enabled = config.modules.user.desktopEnvironment == "gnome";
in {
  system = {
    config = lib.mkIf enabled {
      services.xserver.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
    };
  };
}
