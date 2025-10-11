{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.prismLauncher;
in {
  options.modules.home.programs.prismLauncher.enable = lib.mkEnableOption "Enable PrismLauncher";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
      glfw-wayland
      alsa-oss
      openal
    ];
  };
}
