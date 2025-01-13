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
    home.packages =
      if pkgs.system == "aarch64-darwin"
      then [inputs.nixpkgs.legacyPackages."aarch64-darwin".zellij]
      else [pkgs.zellij];

    xdg.configFile."zellij/config.kdl".text = config_kdl;
    # xdg.configFile."zellij/layouts/default.kdl".text = builtins.readFile ./layouts/default.kdl;
  };
}
