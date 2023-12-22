{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.bottles;
in {
  options.modules.programs.bottles.enable = mkEnableOption "Enable bottles";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.bottles];
  };
}
