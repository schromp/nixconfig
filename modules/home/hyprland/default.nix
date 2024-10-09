{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.hyprland;

  screenshotTool = config.modules.user.screenshotTool;
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./config.nix
    ./hyprlock.nix
  ];

  options.modules.home.programs.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
    xdgOptions = lib.mkEnableOption "Enable premade xdg options";
    sens = lib.mkOption {
      type = lib.types.str;
      default = "1";
    };
    accel = lib.mkOption {
      type = lib.types.str;
      default = "flat";
      description = "Can be flat or adaptive";
    };
    workspace_animations = lib.mkEnableOption "Enable workspace animations";
  };

  config = lib.mkIf cfg.enabled {
    wayland.windowManager.hyprland = {
      enable = true;
      # plugins = [inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix];
      # systemd = true;
    };

    home.packages = with pkgs; [
      brightnessctl # change this to light probably
      wl-clipboard
      swaylock-effects
      swayidle
      libnotify
      xwaylandvideobridge

      slurp
      grim
      hyprpicker

      (
        if screenshotTool == "grimblast"
        then inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
        else if screenshotTool == "satty"
        then satty
        else if screenshotTool == "swappy"
        then swappy
        else null
      )
    ];

    gtk = {
      enable = true;

      theme = {
        name = config.modules.user.theme.name;
        package = config.modules.user.theme.package;
      };

      iconTheme = {
        name = config.modules.user.icon.name;
        package = config.modules.user.icon.package;
      };

      cursorTheme = {
        name = config.modules.user.cursor.name;
        package = config.modules.user.cursor.package;
      };
    };

    services.dunst.enable = true;
  };
}
