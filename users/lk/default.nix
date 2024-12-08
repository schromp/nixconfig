{
  pkgs,
  inputs,
  ...
}: {
  users.users.lk = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio" "wireshark" "docker"];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9t$r/yxsyyrlpxxxy0tptnrc1$.6pbk8mv/f7aeh0bghkdejtfk.7rrissy6wgrtafvh1";
  };

  home-manager.users.lk = {
    imports = [
      ../../modules/home
    ];

    home.packages = [
      pkgs.tldr
      pkgs.spotify-player
      inputs.zen-browser.packages.${pkgs.system}.default
      pkgs.unzip
      pkgs.helix
      pkgs.lazygit
      pkgs.unrar
      pkgs.obsidian
      pkgs.kicad
    ];

    programs = {
      bat.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      firefox.enable = true;
      git = {
        enable = true;
        lfs.enable = true;
      };
      ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            identityFile = "~/.ssh/github";
          };
          "linode" = {
            hostname = "194.233.162.214";
            identityFile = "~/.ssh/linode";
          };
          "git.uni-due.de" = {
            identityFile = "~/.ssh/gitlab-uni-due";
          };
          "git.ude-syssec.de" = {
            hostname = "git.ude-syssec.de";
            identityFile = "~/.ssh/gitlab-syssec";
          };
        };
      };
    };

    modules.home = {
      general = {
        keymap = "us-umlaute";
        theme = {
          name = "dracula";
          font = "Cascadia Code";
          transparent = true;
          colorscheme = {
            name = "dracula";
            nvimName = "dracula"; # WARN: This is a temporary fix
          };
        };
        desktop = {
          defaultTerminal = "kitty";
          defaultBrowser = "firefox";
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
        emacs.enable = true;
        hyprland = {
          enable = true;
          xdgOptions = true;
          workspace_animations = false;

          hyprlock.enable = true;
        };
        kitty.enable = true;
        libreoffice.enable = true;
        neovim.enable = true;
        prismLauncher.enable = true;
        rio.enable = true;
        themer.enable = true;
        tmux.enable = true;
        udiskie.enable = true;
        xdg = {
          enable = true;
          createDirectories = true;
          setAssociations = true;
        };
        yazi.enable = true;
        zellij.enable = true;
        zoxide.enable = true;
        zsh.enable = true;
      };
    };

    home.stateVersion = "24.05";
  };
}
