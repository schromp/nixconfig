{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.zellij;
in {
  options.modules.home.programs.zellij = {
    enable = lib.mkEnableOption "Enable zellij";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [zellij];

    xdg.configFile."zellij/config.kdl".text = builtins.readFile ./config.kdl;
    xdg.configFile."zellij/layouts/default.kdl".text = builtins.readFile ./layouts/default.kdl;
  };
}
