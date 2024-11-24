{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.zellij;
  config_kdl = import ./config_kdl.nix {inherit config;};
in {
  options.modules.home.programs.zellij = {
    enable = lib.mkEnableOption "Enable zellij";
  };

  config = lib.mkIf cfg.enable {
    # Track zellij git package until 0.41.0 is in nixpkgs
    home.packages = [inputs.zellij-git.packages.${pkgs.system}.default];

    xdg.configFile."zellij/config.kdl".text = config_kdl;
    # xdg.configFile."zellij/layouts/default.kdl".text = builtins.readFile ./layouts/default.kdl;
  };
}
