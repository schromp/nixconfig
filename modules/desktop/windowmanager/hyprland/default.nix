{ lib
, inputs
, config
, pkgs
, ...
}:
with lib; let
  opts = config.modules.user;
  username = opts.username;
  enabled = opts.desktopEnvironment == "hyprland";
in
{
  imports = [
    inputs.hyprland.nixosModules.default
    ./config.nix
  ];

  options.modules.programs.hyprland.xdgOptions = mkEnableOption "Enable premade xdg options";

  config = mkIf enabled (mkMerge [
    (mkIf (enabled && opts.displayServerProtocol == "wayland") {
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

      xdg = import ./xdg.nix { inherit pkgs; };

      qt.enable = true;

      home-manager.users.${username} = {
        wayland.windowManager.hyprland = {
          enable = true;
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

          iconTheme = {
            name = "Adwaita";
            package = pkgs.gnome.adwaita-icon-theme;
          };
        };

        services.dunst.enable = true;
      };
    })

    (mkIf config.modules.system.nvidia {
      home-manager.users.${username} = {
        wayland.windowManager.hyprland.enableNvidiaPatches = true;
      };
      hardware = {
        opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
          extraPackages = with pkgs; [
            vaapiVdpau
            libvdpau-va-gl
          ];
        };
        # pulseaudio.support32Bit = true;
      };
    })
    # (mkIf options.modules.desktop.swww.enable {
    #   # TODO: append swww lines to hyprland config
    # })
  ]);
}
