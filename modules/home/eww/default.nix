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

}
