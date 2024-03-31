{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.wacom;
in {
  config = mkIf cfg {
    # services.xserver.wacom.enable = true;
    hardware.opentabletdriver.enable = true;

    # environment.systemPackages = with pkgs; [
    #   xf86_input_wacom
    #   libwacom
    #   wacomtablet
    # ];
  };
}
