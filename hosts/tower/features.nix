{pkgs, ...}: {
  imports = [
    ../../modules
  ];

  config = {
    modules = {
      user = {
        monitors = [
          {
            name = "DP-3";
            resolution = "3440x1440";
            refreshRate = "144";
            scale = "1";
            position = "0x0";
            vrr = true;
          }
          {
            name = "HDMI-A-1";
            resolution = "1920x1080";
            refreshRate = "60";
            scale = "1";
            position = "0x1440";
            vrr = false;
          }
        ];
        keymap = "us-umlaute";
        appRunner = "anyrun";
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
          enable = false;
          createDirectories = true;
          setAssociations = true;
        };
        sddm.enable = false;
        kitty = {
          enable = true;
          theme = "onedark";
        };
        wezterm = {
          enable = true;
        };
        eww.enable = false;
        waybar.enable = true;
        swww.enable = true;
        libreoffice.enable = true;
        discord = {
          enable = true;
          aarpc = false;
        };
        pipewire.enable = true;
        hyprland = {
          sens = "-0.3";
          accel = "flat";
          xdgOptions = true;
          workspace_animations = false;

          hyprlock.enable = true;
        };
        ags = {
          enable = false;
        };
        obsidian.enable = true;
        udiskie.enable = true;
        onedrive.enable = false;

        # Terminal
        ssh.enable = true;
        greetd.enable = false;
        tmux.enable = true;
        zellij.enable = true;
        direnv.enable = true;
        zsh.enable = true;
        zoxide.enable = true;
        bat.enable = true;
        neovim.enable = true;
        git = {
          enable = true; # TODO: make option for username/mail
          lazygit = true;
        };
        nh.enable = true;
        yazi.enable = true;
        rio.enable = true;

        themer = {
          enable = true;
        };

        # Gaming
        gamescope.enable = true;
        prismLauncher.enable = true;
        lutris.enable = true;
        bottles.enable = true;
        steam.enable = true;
        retroarch.enable = false;
        gamemode.enable = true;
      };
    };
  };
}
