{ config, inputs, pkgs, ... }: {

  programs.eww = {
    enable = true;
    package = inputs.eww.packages.x86_64-linux.eww-wayland;
    configDir = config.lib.file.mkOutOfStoreSymlink ./config;
  };

  home.packages = with pkgs; [
    gnused
  #   eww-wayland
  #   pamixer
  #   brightnessctl
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  #
  #
  #home.file.".config/eww/eww.scss".source = ./config/eww.scss;
  #home.file.".config/eww/eww.yuck".source = ./config/eww.yuck;

}
