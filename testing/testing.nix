{
  lib,
  config,
  inputs,
  username,
  ...
}:
with lib; let
  cfg = config.modules.desktop.hyprland;
  hm = inputs.home-manager.nixosModules.home-manager;
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs; # make flake inputs accessible to home manager
    };
    users.${username} = {
      modules = [inputs.hyprland.homeManagerModules.default];
      wayland.windowManager.hyprland.enable = true;
    };
  };
in {
  options.modules.desktop.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = with home-manager;
    mkIf cfg.enable {
      # TODO: add options to nixosModules and home-manager modules
      modules = [
        hm
        home-manager
      ];

      environment.systemPackages = with pkgs; [
        discord
      ];

    };
}
