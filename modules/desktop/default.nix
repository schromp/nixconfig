{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./swww
    #./fonts
    ./kitty
    ./fuzzel
    #./nvidia
    #./themes
    #./hyprland
    ./pipewire
  ];

  home.packages = with pkgs; [
    brightnessctl # change this to light probably
    wl-clipboard
    swaylock-effects
    swayidle
    libnotify
  ];

  services.dunst.enable = true;
}
