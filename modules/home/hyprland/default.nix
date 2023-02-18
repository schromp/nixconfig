{ pkgs, lib, config, inputs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl # change this to light probably
    wl-clipboard
    swaybg
    hyprpaper
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };


  xdg.configFile."hypr/hyprpaper.conf".text = builtins.readFile ./hyprpaper.conf;

  # TODO start the services i need
}
