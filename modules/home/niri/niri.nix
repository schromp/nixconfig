{
  osConfig,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  comp = osConfig.modules.local.system.compositor;
  kitty-cursor = pkgs.runCommand "kitty-cursor" { } ''
    mkdir -p $out/share/icons/kitty-cursor
    cp -r ${../../../extras/private/kitty-cursor}/* $out/share/icons/kitty-cursor/
  '';

in
{
  config = lib.mkIf (comp == "niri") {
    home.file.".config/niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink /home/lk/repos/nixconfig/modules/home/niri/config.kdl;

    home.packages = with pkgs; [
      inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
      brightnessctl
      wl-clipboard

      grim
      slurp
      swappy
      tesseract
    ];

    services.dunst.enable = true;

    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;

      name = "kitty-cursor";

      package = kitty-cursor;
    };

  };
}
