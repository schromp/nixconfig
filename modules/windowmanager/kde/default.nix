{
  lib,
  config,
  ...
}:
with lib; let
  # username = config.modules.username;
  enabled = opts.desktopEnvironment == "kde";
in {
  config = mkIf enabled {
    services.xserver.enable = true;
    # services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
  };
}
