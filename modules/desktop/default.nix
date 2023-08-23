{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common
    ./swww
    ./eww
    ./kitty
    ./fuzzel
    ./nvidia
    #./themes
    ./hyprland
    ./x11
    ./pipewire
  ];

}
