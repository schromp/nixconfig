{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.prismLauncher;
in {
  options.modules.programs.prismLauncher.enable = mkEnableOption "Enable PrismLauncher";

  config = mkIf cfg.enable {
    nixpkgs.config.overlay = with inputs; [
      # prismlauncher.overlay
    ];

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        prismlauncher
        glfw-wayland
        alsa-oss
        openal
      ];
    };
  };
}
