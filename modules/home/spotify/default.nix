{ config, pkgs, inputs, ... }: {
  
  xdg.configFile."spotifyd/spotifyd.conf".text = '' 
    [global]
    username = "lenntleman@gmail.com"
    password_cmd = "bw get password spotify"
  '';

  home.packages = with pkgs; [ spotifyd spotify-tui ];

  # programs.ncspot.enable = true;

}

