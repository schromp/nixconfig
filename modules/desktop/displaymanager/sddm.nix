{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.displaymanager.sddm;
in {
  options.modules.desktop.displaymanager.sddm.enable = mkEnableOption "Enable sddm";

  config = mkIf cfg.enable {
    services.xserver = {
      # enable = true;
      displayManager = {
        gdm.enable = false;
        lightdm.enable = false;
        sddm = {
          enable = true;
          # settings = {
          #   General = {
          #     DisplayServer = "wayland";
          #     # GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
          #   };
          # };
        };
      };
    };
  };
}
