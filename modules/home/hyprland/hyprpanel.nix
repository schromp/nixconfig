{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.hyprland.hyprpanel;
  package = inputs.hyprpanel.packages.${pkgs.system}.default;
in {
  options.modules.home.programs.hyprland.hyprpanel = {
    enable = lib.mkEnableOption "Enable hyprpanel";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      package
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "${lib.getExe package}"
      ];
    };
  };
}
