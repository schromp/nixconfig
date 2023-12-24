{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
with lib; let
  opts = config.modules.user;
  username = opts.username;
  enabled = opts.desktopEnvironment == "hyprland";
in {
  imports = [
    inputs.hyprland.nixosModules.default
    ./config.nix
    # ./xdg.nix
  ];

  options.modules.programs.hyprland = {
    xdgOptions = mkEnableOption "Enable premade xdg options";
    sens = mkOption {
      type = types.str;
      default = "1";
    };
    accel = mkOption {
      type = types.str;
      default = "flat";
      description = "Can be flat or adaptive";
    };
  };

  config = mkIf enabled (mkMerge [
    (mkIf (enabled && opts.displayServerProtocol == "wayland") {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      # add binary cache
      nix.settings.substituters = [
        "https://nixpkgs-wayland.cachix.org"
        "https://hyprland.cachix.org"
      ];
      nix.settings.trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];

      environment = {
        # here we set all important wayland envs
        variables = {
          NIXOS_OZONE_WL = "1";
          GDK_BACKEND = "wayland,x11";
          ANKI_WAYLAND = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_QPA_PLATFORMTHEME = "qt5ct";
          # SDL_VIDEODRIVER = "wayland";

          WLR_BACKEND = "vulkan";
          WLR_RENDERER = "vulkan";

          XDG_CURRENT_DESKTOP = "Hyprland";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "Hyprland";

          # TODO: move this into hidpi option
          GDK_SCALE = "1";
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";

          # TODO: move this into theming module
          # theming
          XCURSOR_SIZE = "24";
          XCURSOR_THEME = "Bibata-Modern-Ice";

          MOZ_ENABLE_WAYLAND = "1";
          # WLR_NO_HARDWARE_CURSORS = "1";
        };
      };

      programs.dconf.enable = true; # TODO: why? my comment said gtk stuff

      sound = {
        mediaKeys.enable = true;
      };

      environment.systemPackages = with pkgs; [xdg-utils];

      qt.enable = true;

      home-manager.users.${username} = {
        imports = [
          inputs.hyprland.homeManagerModules.default
        ];

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

          inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
        ];

        gtk = {
          enable = true;

          theme = {
            name = "Kanagawa";
            package = inputs.self.packages."x86_64-linux".kanagawa-gtk-theme;
          };

          iconTheme = {
            name = "Adwaita";
            package = pkgs.gnome.adwaita-icon-theme;
          };
        };

        services.dunst.enable = false;
      };
    })
  ]);
}
