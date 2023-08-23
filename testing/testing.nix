{ inputs, lib, config, home-manager, ...}:
with lib; let
  cfg = config.modules.desktop.hyprland;
  username = "lk";
  hm = inputs.home-manager.nixosModules.home-manager;
in {

  options.modules.desktop.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = mkIf cfg.enable {
  
    # TODO: add options to nixosModules and home-manager modules

    #modules = [ inputs.hyprland.nixosModules.default hm ];
    modules = [ hm ];

    inputs.home-manager.users.${username} = {
      modules = [ inputs.hyprland.homeManagerModules.default ];
      wayland.windowManager.hyprland.enable = true;
    };
  };

}
