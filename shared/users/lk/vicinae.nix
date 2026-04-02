{ inputs, pkgs, ... }:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    playerctl
  ];

  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      font = {
        normal = {
          family = "CaskaydiaCove Nerd Font";
        };
      };
      theme = {
        dark = {
          name = "matugen";
          icon_theme = "Adwaita";
        };
      };
      launcher_window = {
        opacity = 0.8;
        client_side_decorations = {
          enabled = true;
        };
      };
      providers = {
        "@sovereign/store.vicinae.awww-switcher" = {
          preferences = {
            colorGenTool = "matugen";
            gridRows = "4";
            postProduction = "no";
            showImageDetails = true;
            toggleVicinaeSetting = true;
            transitionDuration = "3";
            transitionFPS = "60";
            transitionStep = "90";
            transitionType = "random";
            wallpaperPath = "/home/lk/Pictures/Wallpaper";
          };
        };
      };
    };

    # package = inputs.vicinae.packages.${pkgs.system}.default;
    # extensions = [
    #   (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
    #     inherit pkgs;
    #     name = "swww-switcher";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "ViSovereign";
    #       repo = "swww-switcher";
    #       rev = "e29515ed74e27e58a631b2d2863bff19941b0c43";
    #       sha256 = "sha256-g+GNKwXNIuhnQ9u5C/wnp5KLwackF+FdOYXFiYk8WSI=";
    #     };
    #   })
    # ];
  };
}
