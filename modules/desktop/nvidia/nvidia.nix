{lib, ...}:
with lib; let
  cfg = options.modules.desktop.nvidia;
in {
  cfg.enable = mkEnableOption "Enable Nvidia Drivers";

  config.nvidia = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];
    #hardware.nvidia.open = true;
    #hardware.nvidia.nvidiaSettings = true;
    #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    hardware.nvidia.modesetting.enable = true;
  };
}
