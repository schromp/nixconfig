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
    backend = mkOption {
      type = types.enum [ "wayland" "x11" ];
      default = "x11";
      description = "Which backend to use. wayland or x11";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.eww = let 
        pkg = if cfg.backend == "wayland" 
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
