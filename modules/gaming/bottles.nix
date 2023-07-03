{ config, lib, pkgs, ...}: with lib; let
  username = import ../../username.nix;
  cfg = config.modules.gaming.bottles;
in {
  options.modules.gaming.bottles.enable = mkEnableOption "Enable bottles";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.bottles];
  };
}
