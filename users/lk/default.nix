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
    ];

    programs = {
      bat.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    modules.home = {
      general = {
        keymap = "us-umlaute";
        theme = {
          name = "terminal";
          font = "Cascadia Code";
          transparent = false;
          colorscheme = {
            name = "gruvbox";
            nvimName = "gruvbox-material"; # WARN: This is a temporary fix
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
        ssh.enable = true;
        themer.enable = true;
        tmux.enable = true;
        udiskie.enable = true;
        yazi.enable = true;
        zoxide.enable = true;
        zsh.enable = true;
      };
    };

    home.stateVersion = "24.05";
  };
}
