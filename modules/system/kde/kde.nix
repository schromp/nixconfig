{
  lib,
  config,
  pkgs,
  ...
}:
let
  comp = config.modules.local.system.compositor;
in
{
  config = lib.mkIf (comp == "kde") {
    services.desktopManager = {
      plasma6.enable = true;
    };
    services.displayManager.plasma-login-manager.enable = true;
  };
}
