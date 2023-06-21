{
  lib,
  inputs,
  home-manager,
  username,
  ...
}:
with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  imports = [
    #../pipewire/default.nix
    #../../input/umlaute.nix
    #../nvidia
    #../fonts # WARN: these are not options but just set and install fonts
  ];

  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Hyprland";

    nvidiaSupport = mkEnableOption "Enable Nvidia Support for Hyprland";

    appRunner = mkOption {
      type = types.enum ["fuzzel"];
      default = "fuzzel";
      description = ''
        Select the App Runner Hyprland should use.
      '';
      example = "fuzzel";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      imports = [
        inputs.hyprland.nixosModules.default
        inputs.hyprland.homeManagerModules.default
      ];

      # add binary cache
      nix.settings.substituters = [
        "https://nixpkgs-wayland.cachix.org"
        "https://hyprland.cachix.org"
      ];
      nix.settings.trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];

      nixpkgs.config.overlay = with inputs; [
        nixpkgs-wayland.overlay
      ];

      # from old config, leaving this for reference if something breaks
      # nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];

      home-manager.users.${username} = {
        wayland.windowManager.hyprland = {
          enable = true;
          systemdIntegration = true;
          extraConfig = builtins.readFile ./hyprland.conf;
        };

        xdg.portal = {
          enable = true;
          wlr.enable = true;
          # xdgOpenUsePortal = true; makes programs open with xdg portal
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];
        };

        programs.dconf.enable = true; # TODO: why? my comment said gtk stuff

        sound = {
          mediaKeys.enable = true;
        };

        environment = {
          # here we set all important wayland envs
          variables = {
            NIXOS_OZONE_WL = "1";
            GDK_BACKEND = "wayland";
            ANKI_WAYLAND = "1";
            QT_QPA_PLATFORM = "wayland;xcb";
            #XDG_SESSION_TYPE = "wayland";
            #XDG_CURRENT_DESKTOP="Hyprland";
            XDG_SESSION_DESKTOP = "Hyprland";
            QT_QPA_PLATFORMTHEME = "qt5ct";

            WLR_BACKEND = "vulkan";
            WLR_RENDERER = "vulkan";

            # TODO: move this into hidpi option
            GDK_SCALE = "1";
            QT_AUTO_SCREEN_SCALE_FACTOR = "1";

            # TODO: move this into theming module
            # theming
            XCURSOR_SIZE = "24";
            XCURSOR_THEME = "Bibata-Modern-Ice";

            MOZ_ENABLE_WAYLAND = "1";
          };
        };
      };
    })

    (mkIf cfg.nvidiaSupport {
      wayland.windowManager.hyprland.nvidiaPatches = true;
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

    (mkIf options.modules.input.umlaute.enable {
      # TODO: append to .conf file
    })

    (mkIf options.modules.desktop.swww.enable {
      # TODO: append swww lines to hyprland config
    })

    (mkMerge [
      (mkIf (builtins.elem ""))
      {
        # TODO: append app runner to keybinds
      }
    ])
  ];
}
