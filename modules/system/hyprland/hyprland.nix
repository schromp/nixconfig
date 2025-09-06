{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.system.programs.hyprland;
in {
  imports = [
    # inputs.hyprland.nixosModules.default
  ];

  options.modules.system.programs.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
    hyprlock = lib.mkEnableOption "Enable hyprlock";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      package = pkgs.hyprland;
    };

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
        XDG_SESSION_TYPE = "wayland";
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

    security.pam.services.hyprlock = lib.mkIf cfg.hyprlock {};

    # This fixes: https://github.com/NixOS/nixpkgs/issues/189851
    # systemd.user.extraConfig = ''
    #   DefaultEnvironment="PATH=/run/current-system/sw/bin"
    # '';
  };
}
