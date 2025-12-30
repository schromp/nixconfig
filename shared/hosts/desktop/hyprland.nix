{lib, config, ...}: let
  comp = config.modules.local.system.compositor;
in {

  config = lib.mkIf (comp == "hyprland") {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
  };
}
