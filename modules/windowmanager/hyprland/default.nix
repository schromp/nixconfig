{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  opts = config.modules.user;
  username = opts.username;
  enabled = opts.desktopEnvironment == "hyprland";

  cfg = config.presets.themes;
  cursor = cfg.cursor;
  theme = cfg.theme;
  icon = cfg.icon;

  screenshotTool = config.modules.user.screenshotTool;
in {
  imports = [
    inputs.hyprland.nixosModules.default
    ./config.nix
    ./hyprlock.nix
  ];

  options.modules.programs.hyprland = {
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
  };

  config = lib.mkIf enabled (lib.mkMerge [
    (lib.mkIf (enabled && opts.displayServerProtocol == "wayland") {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
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
          # ANKI_WAYLAND = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
          # QT_QPA_PLATFORMTHEME = "qt5ct";
          # SDL_VIDEODRIVER = "wayland"; # For csgo

          # WLR_BACKEND = "vulkan";
          # WLR_RENDERER = "vulkan";

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

          # R_DRM_NO_ATOMIC = "1";This disables the usage of a newer kernel DRM API that doesn’t support tearing yet
        };
      };

      programs.dconf.enable = true; # Enable gnome programs outside of gnome better

      sound = {
        mediaKeys.enable = true;
      };

      environment.systemPackages = with pkgs; [xdg-utils];

      # WARN: disabled because this causes issues with the hyprland share picker
      # qt = {
      #   enable = true;
      #   platformTheme = "gtk2";
      #   style = "gtk2";
      # };

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

          slurp
          grim

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
            name = theme.name;
            package = theme.package;
          };

          iconTheme = {
            name = icon.name;
            package = icon.package;
          };

          cursorTheme = {
            name = cursor.name;
            package = cursor.package;
          };
        };

        services.dunst.enable = true;
      };
    })
  ]);
}
