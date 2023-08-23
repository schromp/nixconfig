{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.hyprland;

  systemConfig = {
    modules = [
      inputs.hyprland.nixosModules.default
    ];

    nix.settings.substituters = [
      "https://nixpkgs-wayland.cachix.org"
      "https://hyprland.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];

    nixpkgs.config.overlay = with inputs; [
      nixpkgs-wayland.overlay
    ];
  };

  homeConfig = {
    modules = [
      inputs.hyprland.homeManagerModules.default
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemdIntegration = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # xdgOpenUsePortal = true; makes programs open with xdg portal
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
in {
  options.modules.desktop.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = mkIf cfg.enable {
    system = systemConfig;
    home = homeConfig;
  };
}
