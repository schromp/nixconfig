{...}: {
  imports = [
    ../../modules
    ../../presets
  ];

  config = {
    presets = {
      rices = {
        name = "onedark";
        vertical = true;
      };
    };

    modules = {
      user = {
        homeManager.enabled = true;
        username = "lk";
        repoDirectory = "/home/lk/repos/nixconfig";
        displayServerProtocol = "wayland";
        desktopEnvironment = "hyprland";
        monitor = {
          name = "DP-3";
          resolution = "3440x1440";
          refreshRate = "144";
          scale = "1";
          position = "0x0";
        };
        keymap = "us-umlaute";
        appRunner = "tofi";
        browser = "firefox";
        screenshotTool = "swappy";
      };
      system = {
        nvidia = false;
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
        xdg = {
          enable = true;
          createDirectories = true;
          setAssociations = true;
        };
        sddm.enable = false;
        kitty = {
          enable = true;
          theme = "onedark";
        };
        eww.enable = false;
        waybar.enable = false;
        swww.enable = true;
        libreoffice.enable = true;
        discord = {
          enable = true;
          aarpc = false;
        };
        pipewire.enable = true;
        hyprland = {
          sens = "-0.2";
          accel = "flat";
          xdgOptions = true;
        };
        ags = {
          enable = true;
        };

        # Terminal
        ssh.enable = true;
        greetd.enable = true;
        tmux.enable = true;
        zellij.enable = true;
        direnv.enable = true;
        zsh.enable = true;
        zoxide.enable = true;
        neovim.enable = true;
        git = {
          enable = true; # TODO: make option for username/mail
          lazygit = true;
        };

        # Gaming
        gamescope.enable = true;
        prismLauncher.enable = true;
        lutris.enable = true;
        bottles.enable = true;
        steam.enable = true;
        retroarch.enable = true;
        gamemode.enable = true;
      };
    };
  };
}
