{ config, pkgs, inputs, ... }: {
  
  # the following does not work correctly yet.
  # i have a workaround in the hyprland.conf
  xdg.configFile."spotifyd/spotifyd.conf".text = '' 
    [global]
    username = "lenntleman@gmail.com"
    password_cmd = "bw get password spotify"
  '';

  home.packages = with pkgs; [ spotifyd spotify-tui ];

}

