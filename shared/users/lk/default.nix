{
  pkgs,
  inputs,
  ...
}:
{
  users.users.lk = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "wireshark"
      "docker"
    ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9t$r/yxsyyrlpxxxy0tptnrc1$.6pbk8mv/f7aeh0bghkdejtfk.7rrissy6wgrtafvh1";
  };

  home-manager.users.lk = {
    imports = [
      ../../modules/home

      ./layout.nix
      ./neovim.nix
      ./prismlauncher.nix
      ./yazi.nix
      ./zen.nix
      ./zoxide.nix
    ];

    home.packages = import ./packages.nix {
      inherit pkgs inputs;
    };

    programs = {
      bat.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      firefox.enable = true;
      nheko.enable = true;
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

    services = {
      udiskie = {
        enable = true;
        automount = true;
        notify = true;
      };
    };

    modules.home = {
      general = {
        keymap = "us-umlaute";
        theme = {
          name = "modern";
          font = "Iosevka Nerd Font";
          transparent = true;
          colorscheme = {
            name = "kanagawa";
            nvimName = "kanagawa"; # WARN: This is a temporary fix
            zellijName = "kanagawa";
          };
        };
        desktop = {
          defaultTerminal = "wezterm";
          defaultBrowser = "firefox";
          defaultFileManager = "pcmanfm";
          defaultScreenshotTool = "swappy";
          defaultAppRunner = "vicinae";
        };
      };

      programs = {
        hyprland = {
          enable = true;
          xdgOptions = true;
          workspace_animations = false;
        };
        wezterm.enable = true;
        xdg = {
          enable = true;
          createDirectories = true;
          setAssociations = true;
        };
        zellij.enable = true;
        zsh.enable = true;
      };
    };

    home.stateVersion = "24.05";
  };
}
