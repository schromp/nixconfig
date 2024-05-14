{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.prismLauncher;
in {
  options.modules.programs.prismLauncher.enable = lib.mkEnableOption "Enable PrismLauncher";

  home = {
    config = lib.mkIf cfg.enable {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          prismlauncher
          glfw-wayland
          alsa-oss
        ];
      };
    };
  };
}
