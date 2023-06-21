{inputs, pkgs, ...}: {
  imports = [../../modules ];

  config.home.stateVersion = "23.11";

  config.modules = {
    terminal = {
      git.enable = true; # TODO: make option for username/mail
      direnv.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };

    #desktop = {
      #hyprland.enable = true;
    #};
  };
}
