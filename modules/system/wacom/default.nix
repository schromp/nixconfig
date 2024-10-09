{
  config,
  lib,
  ...
}: let
  cfg = config.modules.system.programs.wacom;
in {
  config = lib.mkIf cfg {
    hardware.opentabletdriver.enable = true;
  };
}
