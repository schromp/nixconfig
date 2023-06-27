{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./swww
    # ./fonts
    ./kitty
    ./fuzzel
    ./nvidia
    #./themes
    ./hyprland
    ./pipewire
  ];

}
