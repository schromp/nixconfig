{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.bottles;
in {
  system = {
    options.modules.programs.bottles.enable = lib.mkEnableOption "Enable bottles";

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [pkgs.bottles];
    };
  };
}
