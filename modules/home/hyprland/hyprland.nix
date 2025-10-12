{
  osConfig,
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  comp = osConfig.modules.local.system.compositor;

  screenshotTool = config.modules.home.general.desktop.defaultScreenshotTool;
in
{
  imports = [
    inputs.wired.homeManagerModules.default

    ./config.nix
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

  config = lib.mkIf (comp == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
    };

    home.packages = with pkgs; [
      brightnessctl
      wl-clipboard
      swaylock-effects
      swayidle
      libnotify
      swww

      slurp
      grim
      hyprpicker

      (
        if screenshotTool == "grimblast" then
          inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
        else if screenshotTool == "satty" then
          satty
        else if screenshotTool == "swappy" then
          swappy
        else
          null
      )
    ];

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    gtk = {
      enable = true;

      theme = {
        name = "Catppuccin-Macchiato-Standard-Pink-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "pink" ];
          size = "standard";
          tweaks = [ ];
          variant = "macchiato";
        };
      };

      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };

      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
    };

    services = {
      gnome-keyring.enable = true;
      wired = {
        enable = true;
      };
    };
  };
}
