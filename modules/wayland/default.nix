{ config, pkgs, inputs, ... }:
{
  imports = [ ./services.nix ./fonts.nix ];
  nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];

  environment = {
    # here we set all important wayland envs
    variables = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland";
      ANKI_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      #XDG_SESSION_TYPE = "wayland";
      #XDG_CURRENT_DESKTOP="Hyprland";
      XDG_SESSION_DESKTOP="Hyprland";
      QT_QPA_PLATFORMTHEME = "qt5ct";

      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";

      GDK_SCALE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      # theming
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = "Bibata-Modern-Ice";

    };
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

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      #inputs.xdg-portal-hyprland.packages.${pkgs.system}.default
    ];
  };

  # this is needed for gtk stuff it seems
  programs.dconf.enable = true;

  sound = {
    mediaKeys.enable = true;
  };
}
