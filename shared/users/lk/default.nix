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
    shell = pkgs.fish;
    hashedPassword = "$y$j9t$r/yxsyyrlpxxxy0tptnrc1$.6pbk8mv/f7aeh0bghkdejtfk.7rrissy6wgrtafvh1";
  };

  home-manager.users.lk = {
    imports = [
      ../../../modules/home

      ./layout.nix
      ./neovim.nix
      ./yazi.nix
      ./zen.nix
      ./zoxide.nix
      ./ssh.nix
      ./ghostty/ghostty.nix
      ./helix/helix.nix
      ./vicinae.nix
      ./fish.nix
      ./matugen/matugen.nix
      ./helix/helix.nix
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
      easyeffects = {
        enable = true;
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
