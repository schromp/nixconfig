{
  inputs,
  config,
  lib,
  pkgs,
  sysConfig,
  ...
}: let
  cfg = config.modules.home.programs.zellij;
  config_kdl = import ./config_kdl.nix {inherit config;};
  desktop_layout = import ./layouts/desktop.kdl.nix {inherit config sysConfig;};
in {
  options.modules.home.programs.zellij = {
    enable = lib.mkEnableOption "Enable zellij";
  };

  config = lib.mkIf cfg.enable {
    home.packages = let
      zellijPkg =
        if pkgs.system == "aarch64-darwin"
        then inputs.nixpkgs.legacyPackages."aarch64-darwin".zellij
        else pkgs.zellij;
    in
      with pkgs; [
        zellijPkg
      ];

    xdg.configFile."zellij/config.kdl".text = config_kdl;

    xdg.configFile."zellij/layouts/desktop.kdl".text = desktop_layout;
  };
}
