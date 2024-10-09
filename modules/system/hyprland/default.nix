{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.system.progams.hyprland;

  screenshotTool = config.modules.user.screenshotTool;
in {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  options.modules.system.programs.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf cfg.enabled {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    # TODO: move this
    nix.settings.substituters = [
      "https://nixpkgs-wayland.cachix.org"
      "https://hyprland.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];

    # TODO: is this up to date?
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

        # XDG_CURRENT_DESKTOP = "Hyprland";
        # XDG_SESSION_TYPE = "wayland";
        # XDG_SESSION_DESKTOP = "Hyprland";

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

    environment.systemPackages = with pkgs; [xdg-utils];
  };
}
