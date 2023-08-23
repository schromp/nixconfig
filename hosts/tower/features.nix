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

      # displaymanager.sddm.enable = true;

      hyprland.enable = true;
      hyprland.nvidiaSupport = true;

      x11.i3.enable = true;
      x11.config.mouse = false;

      eww.enable = true;
      eww.backend = "wayland";
      swww.enable = true;

      nvidia.enable = true;
      pipewire.enable = true;
      kitty.enable = true;
    };

    gaming = {
      prismLauncher.enable = true;
      lutris.enable = false;
      bottles.enable = false;
    };

    input = {
      umlaute.enable = true;
      wacom.enable = true;
    };
  };
}
