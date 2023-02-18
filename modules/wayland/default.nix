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
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      XDG_SESSION_TYPE = "wayland";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      #WLR_DRM_DEVICES = "/dev/dir/card1:/dev/dri/card0/";
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
    pulseaudio.support32Bit = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      inputs.xdg-portal-hyprland.packages.${pkgs.system}.default
    ];
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
}
