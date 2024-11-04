{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.system.programs.cosmic;
in {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  options.modules.system.programs.cosmic = {
    enable = lib.mkEnableOption "Enable cosmic desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
    };
    environment.systemPackages = [pkgs.wl-clipboard];

    nix.settings = {
      substituters = ["https://cosmic.cachix.org/"];
      trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
    };
  };
}
