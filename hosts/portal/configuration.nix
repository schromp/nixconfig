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
  system.primaryUser = "lennart.koziollek";

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
    home.flakePath = "/Users/lennart.koziollek/Repos/nixconfig";

    imports = [
      ../../modules/home/options.nix
      ../../modules/home/theme/theme.nix
      ../../modules/home/kitty/kitty.nix
      ../../modules/home/wezterm/wezterm.nix
      ../../modules/home/zsh/zsh.nix

      ../../shared/users/lk/options.nix
      ../../shared/users/lk/neovim.nix
      ../../shared/users/lk/yazi.nix
      ../../shared/users/lk/zoxide.nix
      ../../shared/users/lk/ghostty/ghostty.nix
      ../../shared/users/lk/matugen/matugen.nix
      ../../shared/users/lk/fish.nix
      ../../shared/users/lk/zellij/zellij.nix
      ../../shared/users/lk/opencode/opencode.nix
      ../../shared/users/lk/k9s.nix
    ];

    home.packages = with pkgs; let
      php = pkgs.php84.buildEnv {
          extensions = { enabled, all }: enabled ++ (with all; [ opentelemetry ]); 
        };
    in [
      # openfortivpn
      lazygit
      htop
      tldr
      jira-cli-go
      rio
      helix

      # spotify
      spicetify-cli
      raycast
      unnaturalscrollwheels
      nh
      flashspace

      jq
      # yaml-language-server
      colima
      devpod
      nodejs_22
      # openssh
      terraform
      awscli
      _1password-cli
      gum

      argocd
      minio-client

      (pkgs.php.withExtensions ({ enabled, all }: enabled ++ [ all.opentelemetry ])).packages.composer
      php
    ];

    home.sessionVariables = {
      XDG_CONFIG_HOME = "/Users/lennart.koziollek/.config";
    };

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      git = {
        enable = true;
      };
      ssh = {
        enable = true;
        enableDefaultConfig = true;
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
        zsh.enable = true;
        wezterm.enable = true;
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      # (nerdfonts.override {
      #   fonts = [
      #     "JetBrainsMono"
      #     "Iosevka"
      #     "FiraCode"
      #     "Hermit"
      #     "SpaceMono"
      #     "OpenDyslexic"
      #     "Terminus"
      #     "BigBlueTerminal"
      #     "HeavyData"
      #   ];
      # })
      fira-code
      cascadia-code
      open-dyslexic
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

  # system.activationScripts.postUserActivation.text = ''
  #   # Following line should allow us to avoid a logout/login cycle when changing macos options
  #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  # '';

  security.pam.services.sudo_local.touchIdAuth = true;
}
