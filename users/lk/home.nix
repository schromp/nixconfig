{...}: {
  imports = [
    ../../modules/home
  ];

  config = {
    home.packages = [];

    programs = {
      bat.enable = true;
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    modules = {
      general = {
        keymap = "us-umlaute";
        desktop = {
          defaultTerminal = "rio";
          defaultBrowswer = "firefox";
          defaultFileManager = "pcmanfm";
          defaultScreenshotTool = "swappy";
          defaultAppRunner = "anyrun";
        };
      };

      programs = {
        anyrun.enable = true;
        discord = {
          enable = true;
        };
        hyprland = {
          enable = true;
          sens = "-0.3";
          accel = "flat";
          xdgOptions = true;
          workspace_animations = false;

          hyprlock.enable = true;
        };
        libreoffice.enable = true;
        neovim.enable = true;
        rio.enable = true;
        themer.enable = true;
        tmux.enable = true;
        udiskie.enable = true;
        waybar.enable = true;
        yazi.enable = true;
        zoxide.enable = true;
        zsh.enable = true;
      };
    };

    home.stateVersion = "24.05";
  };
}
