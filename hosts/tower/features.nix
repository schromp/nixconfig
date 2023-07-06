{...}: {
  imports = [../../modules];

  config.modules = {
    user = {
      username = "lk";
      displayServerProtocol = "wayland";
      desktopEnvironment = "hyprland";
      keymap = "us-umlaute";
    };

    system = {
      nvidia = true;
      wacom = true;
      bluetooth = true;
    };

    programs = {
      # Common programs
      installCommon = {
        terminal = true;
        desktop = true;
      };

      # Desktop
      # sddm.enable = true;
      kitty.enable = true;
      eww.enable = true;

      # Terminal
      tmux.enable = true;
      zellij.enable = true;
      direnv.enable = true;
      zsh.enable = true;
      neovim.enable = true;
      git = {
        enable = true; # TODO: make option for username/mail
        lazygit = true;
      };

      # Gaming
      prismLauncher.enable = true;
      lutris.enable = true;
      bottles.enable = false;
      steam.enable = true;
    };

    desktop = {
      # TODO: this has to be generalized somehow
      swww.enable = true;
      pipewire.enable = true;
    };
  };
}
