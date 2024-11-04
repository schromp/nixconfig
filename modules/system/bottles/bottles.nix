{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.programs.bottles;
in {
  options.modules.system.programs.bottles.enable = lib.mkEnableOption "Enable bottles";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.bottles];
  };
}
