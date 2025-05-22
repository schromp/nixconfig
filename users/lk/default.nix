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
      pkgs.unzip
      pkgs.helix
      pkgs.lazygit
      pkgs.unrar
      pkgs.obsidian
      # pkgs.fluffychat
      pkgs.element-desktop
      pkgs.signal-desktop
      pkgs.flavours
      pkgs.nomacs
      pkgs.krita
      pkgs.teamspeak6-client
      pkgs.iamb
      pkgs.pureref
      # mpkgs.kicad
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
        extraConfig = {
          init = {
            defaultBranch = "main";
          };
        };
      };
      ssh = {
        enable = true;
        forwardAgent = true;
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
          "cloudy" = {
            hostname = "157.180.37.119";
            identityFile = "~/.ssh/hetzner-cloudy";
          };
          "sparrow" = {
            hostname = "192.168.178.2";
            identityFile = "~/.ssh/hetzner-cloudy";
          };
          "quiescent" = {
            user = "root";
            hostname = "192.168.178.3";
            identityFile = "~/.ssh/hetzner-cloudy";
          };
        };
      };
    };
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    modules.home = {
      general = {
        keymap = "us-umlaute";
        theme = {
          name = "modern";
          font = "Iosevka Nerd Font";
          transparent = false;
          colorscheme = {
            name = "kanagawa";
            nvimName = "kanagawa"; # WARN: This is a temporary fix
            zellijName = "kanagawa";
          };
        };
        desktop = {
          defaultTerminal = "kitty";
          defaultBrowser = "firefox";
          defaultFileManager = "pcmanfm";
          defaultScreenshotTool = "swappy";
          # defaultAppRunner = "anyrun";
        };
      };

      programs = {
        # anyrun.enabled = true;
        discord = {
          enable = true;
        };
        emacs.enable = true;
        hyprland = {
          enable = false;
          xdgOptions = false;
          workspace_animations = false;

          hyprlock.enable = false;
        };
        ghostty.enable = true;
        sway.enable = true;
        kitty.enable = true;
        libreoffice.enable = true;
        neovim.enable = true;
        nushell.enable = false;
        prismLauncher.enable = true;
        rio.enable = true;
        themer.enable = true;
        tmux.enable = true;
        udiskie.enable = false;
        wezterm.enable = true;
        ironbar.enable = true;
        walker.enable = false;
        xdg = {
          enable = true;
          createDirectories = true;
          setAssociations = true;
        };
        yazi.enable = true;
        zellij.enable = true;
        zoxide.enable = true;
        zsh.enable = true;
        zen.enable = true;
      };
    };

    home.stateVersion = "24.05";
  };
}
