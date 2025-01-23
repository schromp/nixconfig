{ inputs, config, lib, pkgs, ...}: let
  cfg = config.modules.home.programs.ghostty;
in {
  options.modules.home.programs.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.ghostty];
  };
}
