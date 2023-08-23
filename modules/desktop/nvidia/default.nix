{lib, config, ...}:
with lib; let
  cfg = config.modules.desktop.nvidia;
in {
  options.modules.desktop.nvidia.enable = mkEnableOption "Enable Nvidia Drivers";

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];
    #hardware.nvidia.open = true;
    #hardware.nvidia.nvidiaSettings = true;
    #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    hardware.nvidia.modesetting.enable = true;
  };
}
