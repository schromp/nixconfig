{
  inputs,
  home-manager,
  config,
  pkgs,
  lib,
  ...
}: let
  sysConfig = config;
in {
  imports = [
    ../../modules/system/options.nix
  ];

  modules.system.general = {
    hostname = "M65L7Q9X32";
    configPath = "/Users/lennart.koziollek/Repos/nixconfig";
  };

  environment.systemPackages = with pkgs; [vim docker neovide coreutils mkpasswd];

  # Auto upgrade nix package and the daemon service.
  services = {
    nix-daemon.enable = true;
  };
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users."lennart.koziollek" = {
    description = "test";
    home = "/Users/lennart.koziollek";
  };

  # inputs.home-manager.useGlobalPkgs = true;
  # inputs.home-manager.useUserPackages = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs sysConfig;
    };
  };

  home-manager.users."lennart.koziollek" = {
    home.stateVersion = "24.11";
    home.username = "lennart.koziollek";
    home.homeDirectory = "/Users/lennart.koziollek";

    home.packages = with pkgs; [
      # openfortivpn
      lazygit
      htop
      tldr
      jira-cli-go
      rio
      helix

      spotify
      spicetify-cli
      raycast
      unnaturalscrollwheels
      nh

      jq
      # yaml-language-server
      colima
      devpod
      php83Packages.composer
      php83
      nodejs_23
      # openssh
      terraform
      awscli
      _1password-cli
      gum
      inputs.mcphub-nvim.packages."${system}".default

      argocd
      minio-client
    ];

    home.sessionVariables = {
      XDG_CONFIG_HOME = "/Users/lennart.koziollek/.config";
    };

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      ssh = {
        enable = true;
        addKeysToAgent = "yes";
        includes = ["~/.ssh/indi-ssh-config/config.d/*"];
        extraConfig = ''
          UseKeychain yes
          SetEnv TERM=xterm-256color
          IdentityFile /Users/lennart.koziollek/.ssh/id_ed_25519_2025
        '';
        matchBlocks = {
          "github.com" = {
            identityFile = "/Users/lennart.koziollek/.ssh/github";
          };
          "bitbucket.check24.de" = {
            identityFile = "/Users/lennart.koziollek/.ssh/id_ed25519_black_bitbucket";
          };
          "bitbucket.org" = {
            identityFile = "/Users/lennart.koziollek/.ssh/id_ed25519_black_bitbucket";
          };
          "https://git.ude-syssec.de" = {
            identityFile = "/Users/lennart.koziollek/.ssh/syssec";
          };
        };
      };
    };

    imports = [
      ../../modules/home/options.nix
      ../../modules/home/theme/theme.nix
      ../../modules/home/zellij/zellij.nix
      ../../modules/home/kitty/kitty.nix
      ../../modules/home/tmux/tmux.nix
      ../../modules/home/wezterm/wezterm.nix
      ../../modules/home/zsh/zsh.nix

      ../../shared/users/lk/neovim.nix
      ../../shared/users/lk/yazi.nix
      ../../shared/users/lk/zoxide.nix
    ];

    modules.home = {
      general = {
        keymap = "us-umlaute";
        theme = {
          name = "terminal";
          font = "Cascadia Code NF";
          transparent = false;
          colorscheme = {
            name = "rose-pine-moon";
            nvimName = "rose-pine-moon"; # WARN: This is a temporary fix
            zellijName = "rose-pine-moon";
          };
        };
      };

      programs = {
        kitty.enable = true;
        tmux.enable = true;
        zsh.enable = true;
        zellij.enable = true;
        wezterm.enable = true;
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "Iosevka"
          "FiraCode"
          "Hermit"
          "SpaceMono"
          "OpenDyslexic"
          "Terminus"
          "BigBlueTerminal"
          "HeavyData"
        ];
      })
      cascadia-code
      open-dyslexic
      nerdfonts
    ];
  };

  homebrew = {
    enable = true;

    brews = [
      "salt-lint"
      # "openssh"
      "sketchybar"
      "netbirdio/tap/netbird"
      "gemini-cli"
    ];
    casks = [
      "michaelroosz/ssh/libsk-libfido2-install"
      "whatsapp"
      "nikitabobko/tap/aerospace"
      "orbstack"
      "proton-pass"
      "flameshot"
      "obsidian"
      "ghostty"
      "element"
      "vial"
      "netbirdio/tap/netbird-ui"
    ];
    taps = [
      "FelixKratz/formulae"
    ];
  };

  # System settings
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      static-only = false;
    };
    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
      QuitMenuItem = true;
    };
    NSGlobalDomain.KeyRepeat = 1;
  };

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle when changing macos options
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  security.pam.enableSudoTouchIdAuth = true;
}
