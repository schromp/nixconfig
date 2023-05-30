{ config, inputs, pkgs, ... }: {

  programs.eww = {
    enable = true;
    package = inputs.eww.packages.x86_64-linux.eww-wayland;
    configDir = ./config;
  };

  # home.packages = with pkgs; [
  #   eww-wayland
  #   pamixer
  #   brightnessctl
  #   (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  # ];
  #
  #
  # home.file.".config/eww/eww.scss".source = ./eww.scss;
  # home.file.".config/eww/eww.yuck".source = ./eww.yuck;

}
