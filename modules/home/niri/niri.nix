{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  comp = osConfig.modules.local.system.compositor;
in
{
  config = lib.mkIf (comp == "niri") {
    home.file.".config/niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink /home/lk/repos/nixconfig/modules/home/niri/config.kdl;

    home.packages = with pkgs; [
      swww
      brightnessctl
      wl-clipboard

      grim
      slurp
      swappy
      tesseract
    ];

    services.wired.enable = true;

  };
}
