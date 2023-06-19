{
  config,
  pkgs,
  ...
}: {
  modules = [
    # TODO: move these behind a option
    ./hyprland
    ./swww
    ./fuzzel
    ./kitty
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
