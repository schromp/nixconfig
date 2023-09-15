{lib, config, ...}:
with lib; let
  cfg = config.modules.system.nvidia;
in {
  config = mkIf cfg {
    services.xserver.videoDrivers = ["nvidia"];
    # hardware.nvidia.open = true;
    #hardware.nvidia.nvidiaSettings = true;
    #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    hardware.nvidia.modesetting.enable = true;
  };
}
