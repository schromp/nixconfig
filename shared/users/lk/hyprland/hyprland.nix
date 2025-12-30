{inputs, pkgs, config, osConfig, lib, ...}: let
  comp = osConfig.modules.local.system.compositor;
  kitty-cursor = pkgs.runCommand "kitty-cursor" { } ''
    mkdir -p $out/share/icons/kitty-cursor
    cp -r ${inputs.non_public_files}/extras/private/kitty-cursor/* $out/share/icons/kitty-cursor/
  '';
in {
  config = lib.mkIf (comp == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
    };

    home.packages = with pkgs; [
      wl-clipboard
      inputs.awww.packages.${pkgs.stdenv.hostplatform.system}.awww

      grim
      slurp
      swappy
    ];

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;

      name = "kitty-cursor";

      package = kitty-cursor;
    };

    services.dunst.enable = true;

    xdg.configFile."hypr/hyprland.conf".source = 
      config.lib.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/hyprland/hyprland.conf";
    };
}
