{...}: {
  imports = [../../modules];

  config.modules = {
    terminal = {
      commonPackages = true;
      git.enable = true; # TODO: make option for username/mail
      direnv.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      neovim.enable = true;
    };

    desktop = {
      commonPackages = true;
      hyprland.enable = true;
      hyprland.nvidiaSupport = true;
      swww.enable = true;
      eww.enable = true;
      nvidia.enable = true;
      pipewire.enable = true;
      kitty.enable = true;
    };

    gaming = {
      prismLauncher.enable = true;
    };

    input = {
      umlaute.enable = true;
    };
  };
}
