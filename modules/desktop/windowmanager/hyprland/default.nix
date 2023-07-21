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
  cfg = config.modules.programs.hyprland;
in {
  options.modules.programs.hyprland.config = {
    keybinds = {
      mainMod = mkOption {
        type = types.str;
        default = "SUPER";
      };

      binds = mkOption {
        type = with types;
          listOf (submodule {
            options = {
              modifier = mkOption {
                type = types.str;
                default = "$mainMod";
                example = "$mainMod CONTROL";
              };
              key = mkOption {
                type = types.str;
                default = " ";
              };
              keyword = mkOption {
                type = types.str;
                example = "exec";
                default = " ";
              };
              command = mkOption {
                type = types.str;
                example = "firefox";
                default = " ";
              };
              mouseBind = mkOption {
                type = types.bool;
                example = "true";
                default = false;
                description = "If the bind is a mousebind. Uses bindm instead of bind";
              };
            };
          });
      };
    };

    general = {
      gaps_in = mkOption {
        type = types.int;
        default = 0;
      };
      gaps_out = mkOption {
        type = types.int;
        default = 0;
      };
      border_size = mkOption {
        type = types.int;
        default = 1;
      };
      col_active_border = mkOption {
        type = types.str;
        default = "00000000";
        description = "rgba value";
      };
      col_inactive_border = mkOption {
        type = types.str;
        default = "00000000";
        description = "rgba value";
      };
    };

    animations = {
      enabled = mkOption {
        type = types.str;
        default = "yes";
        description = "yes or no";
      };
      # TODO: add other animation options
    };
  };

  # imports = [
  # inputs.hyprland.nixosModules.default
  # ];

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

      nixpkgs.config.overlay = with inputs; [
        nixpkgs-wayland.overlay
      ];

      # from old config, leaving this for reference if something breaks
      # nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];

      environment = {
        # here we set all important wayland envs
        variables = {
          NIXOS_OZONE_WL = "1";
          GDK_BACKEND = "wayland";
          ANKI_WAYLAND = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
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
          # LIBSEAT_BACKEND = "logind";
        };
      };

      programs.dconf.enable = true; # TODO: why? my comment said gtk stuff

      sound = {
        mediaKeys.enable = true;
      };

      xdg.portal = {
        enable = true;
        wlr.enable = false;
        # xdgOpenUsePortal = true; makes programs open with xdg portal
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      programs.hyprland.enable = true; # WARN: this might be problematic because its not the flake input

      home-manager.users.${username} = {
        imports = [
          inputs.hyprland.homeManagerModules.default
        ];

        wayland.windowManager.hyprland = {
          enable = true;
          systemdIntegration = true;
          # extraConfig = builtins.readFile ./hyprland.conf;
          extraConfig = import ./config.nix {inherit config lib;};
        };

        home.packages = with pkgs; [
          brightnessctl # change this to light probably
          wl-clipboard
          swaylock-effects
          swayidle
          libnotify

          inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
        ];

        services.dunst.enable = true;
      };
    })

    (mkIf config.modules.system.nvidia {
      programs.hyprland.nvidiaPatches = true;
      home-manager.users.${username} = {
        wayland.windowManager.hyprland.nvidiaPatches = true;
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

    # (mkIf options.modules.input.umlaute.enable {
    #   # TODO: append to .conf file
    # })
    #
    # (mkIf options.modules.desktop.swww.enable {
    #   # TODO: append swww lines to hyprland config
    # })
    #
    # (mkMerge [
    #   (mkIf (builtins.elem ""))
    #   {
    #     # TODO: append app runner to keybinds
    #   }
    # ])
  ]);
}
