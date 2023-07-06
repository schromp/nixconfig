{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.eww;
in {
  options.modules.programs.eww = {
    enable = mkEnableOption "Enable Eww";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.eww = let 
        pkg = if config.modules.user.displayServerProtocol == "wayland" 
        then inputs.eww.packages.x86_64-linux.eww-wayland
        else
          pkgs.eww;
      in {
        enable = true;
        package = pkg;
        # configDir = config.lib.file.mkOutOfStoreSymlink ./config;
        configDir = ./config; # TODO: make configurable through nix
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
