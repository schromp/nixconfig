{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.input.wacom;
in {
  options.modules.input.wacom.enable = mkEnableOption "Enable Wacom drivers";

  config = mkIf cfg.enable {
    services.xserver.wacom.enable = true;
    hardware.opentabletdriver.enable = true;

    environment.systemPackages = with pkgs; [
      xf86_input_wacom
      libwacom
      wacomtablet
    ];

  };
}
