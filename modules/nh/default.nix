{ inputs, config, lib, pkgs }: let
  cfg = config.modules.programs.nh;
in {
  options.modules.programs.nh = {
    enable = lib.mkEnableOption "Enable nh cli tool";
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = ~/repos/nixconfig;
    };
  };
}
