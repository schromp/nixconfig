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
      sddm.enable = false;
      kitty.enable = true;
      eww.enable = true;
      libreoffice.enable = true;
      discord = {
        enable = true;
        aarpc = false;
      };

      # Terminal
      greetd.enable = true;
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
      bottles.enable = true;
      steam.enable = true;
      retroarch.enable = true;
    };

    desktop = {
      # TODO: this has to be generalized somehow
      swww.enable = true;
      pipewire.enable = true;
    };
  };
}
