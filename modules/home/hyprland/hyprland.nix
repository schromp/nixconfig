{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.home.programs.hyprland;

  screenshotTool = config.modules.home.general.desktop.defaultScreenshotTool;
in
{
  imports = [
    inputs.wired.homeManagerModules.default
    inputs.vicinae.homeManagerModules.default

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

  config = lib.mkIf cfg.enable {
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
      vicinae = {
        enable = true;
        autoStart = true;
        package = inputs.vicinae.packages.${pkgs.system}.default;
        extensions = [
          (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
            inherit pkgs;
            name = "test-extension";
            src =
              pkgs.fetchFromGitHub {
                owner = "schromp";
                repo = "vicinae-extensions";
                rev = "f8be5c89393a336f773d679d22faf82d59631991";
                sha256 = "sha256-zk7WIJ19ITzRFnqGSMtX35SgPGq0Z+M+f7hJRbyQugw=";
              }
              + "/test-extension";
          })
          (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
            inherit pkgs;
            name = "swww-switcher";
            src = pkgs.fetchFromGitHub {
              owner = "ViSovereign";
              repo = "swww-switcher";
              rev = "e29515ed74e27e58a631b2d2863bff19941b0c43";
              sha256 = "sha256-g+GNKwXNIuhnQ9u5C/wnp5KLwackF+FdOYXFiYk8WSI=";
            };
          })
        ];
      };
    };
  };
}
