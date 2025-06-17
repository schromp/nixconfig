{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.quickshell;
in {
  options.modules.home.programs.quickshell = {
    enable = lib.mkEnableOption "Enable Quickshell";
  };

  config = lib.mkIf cfg.enable {
    qt.enable = true;
    home.packages = [
      inputs.quickshell.packages.${pkgs.system}.default
      pkgs.kdePackages.qtdeclarative
    ];
  };
}
