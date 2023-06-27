{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.desktop.eww;
in {
  options.modules.desktop.eww = {
    enable = mkEnableOption "Enable Eww";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.eww = {
        enable = true;
        package = inputs.eww.packages.x86_64-linux.eww-wayland;
        # configDir = config.lib.file.mkOutOfStoreSymlink ./config;
        configDir = ./config;
      };

      home.packages = with pkgs; [
        gnused
        #   eww-wayland
        #   pamixer
        #   brightnessctl
        (nerdfonts.override {fonts = ["JetBrainsMono"];})
      ];
    };
  };
}
