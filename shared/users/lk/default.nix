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
      "dialout"
    ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9t$r/yxsyyrlpxxxy0tptnrc1$.6pbk8mv/f7aeh0bghkdejtfk.7rrissy6wgrtafvh1";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILa3o+D922G1gYVtzVSTjPRwq79u/LT7bosxakSOKRhc herdr-mobile"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOwXTCcORxRR62+qZn7u9x56KJSLoyrIWb/ZstB/2Nhd herdr-ipad"
    ];
  };

  home-manager.users.lk = {
    imports = [
      ../../../modules/home
      ./options.nix

      ./layout.nix
      ./neovim.nix
      ./yazi.nix
      ./zen.nix
      ./zoxide.nix
      ./ssh.nix
      ./ghostty/ghostty.nix
      ./helix/helix.nix
      ./vicinae.nix
      ./helix/helix.nix
      # ./noctalia/noctalia.nix
      # ./dms/dms.nix
      ./zellij/zellij.nix
      # ./opencode/opencode.nix
      ./pi/pi.nix
      ./herdr/herdr.nix
      ./agent-skills.nix
      ./agents
      ./vesktop.nix
      ./wezterm/wezterm.nix
      ./nushell/nushell.nix
      ./emacs/emacs.nix
    ];

    home.flakePath = "/home/lk/repos/nixconfig";

    home.packages = import ./packages.nix {
      inherit pkgs inputs;
    };

    programs = {
      bat.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      firefox = {
        enable = true;
        package = inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin;
      };
      nheko.enable = true;
      git = {
        enable = true;
        lfs.enable = true;
        signing.format = null;
        settings = {
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
      easyeffects = {
        enable = false;
      };
    };

    modules.home = {
      general = {
        keymap = "us-umlaute";
        desktop = {
          defaultTerminal = "wezterm";
          defaultBrowser = "firefox";
          defaultFileManager = "pcmanfm";
          defaultScreenshotTool = "swappy";
          defaultAppRunner = "vicinae";
        };
      };

      programs = {
        npm.enable = true;
        xdg = {
          enable = true;
          createDirectories = true;
          setAssociations = true;
        };
        zsh.enable = true;
      };
    };

    home.stateVersion = "24.05";
  };
}
