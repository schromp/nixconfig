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
        extraConfig = ''
          UseKeychain yes
          SetEnv TERM=xterm-256color
        '';
        matchBlocks = let
          createIndiServers = subnet: servers:
            builtins.listToAttrs (
              map (server: {
                name = server.name;
                value = {
                  host = server.name;
                  hostname = "10.111.${builtins.toString subnet}.${builtins.toString server.ip}";
                  port = 42022;
                  identityFile = "/Users/lennart.koziollek/.ssh/id_ed_25519_2025";
                };
              })
              servers
            );
        in
          (createIndiServers 127 [
            {
              name = "ir-uti1";
              ip = 101;
            }
            {
              name = "ir-uti2";
              ip = 102;
            }
            {
              name = "ir-uti3";
              ip = 103;
            }
            {
              name = "ir-uti4";
              ip = 104;
            }
            {
              name = "ir-uti5";
              ip = 105;
            }
            {
              name = "ir-uti6";
              ip = 106;
            }
            {
              name = "ir-uti7";
              ip = 107;
            }
            {
              name = "ir-uti8";
              ip = 108;
            }
            {
              name = "ir-uti9";
              ip = 109;
            }
            {
              name = "ir-uti10";
              ip = 110;
            }
            {
              name = "ir-uti-m01";
              ip = 121;
            }
            {
              name = "ir-pve-t01";
              ip = 231;
            }
            {
              name = "ir-pve-t02";
              ip = 232;
            }
            {
              name = "ir-pve-p01";
              ip = 131;
            }
            {
              name = "ir-pve-p02";
              ip = 132;
            }
            {
              name = "ir-lb-p01";
              ip = 11;
            }
            {
              name = "ir-lb-p02";
              ip = 12;
            }
            {
              name = "ir-lb-t01";
              ip = 201;
            }
            {
              name = "ir-lb-t02";
              ip = 202;
            }
            {
              name = "ir-fe-p01";
              ip = 31;
            }
            {
              name = "ir-fe-p02";
              ip = 32;
            }
            {
              name = "ir-web-p01";
              ip = 51;
            }
            {
              name = "ir-web-p02";
              ip = 52;
            }
            {
              name = "ir-db-t01";
              ip = 221;
            }
            {
              name = "ir-db-t02";
              ip = 222;
            }
            {
              name = "ir-dbm-p01";
              ip = 81;
            }
            {
              name = "ir-dbs-p01";
              ip = 82;
            }
            {
              name = "ir-web-t01";
              ip = 211;
            }
            {
              name = "ir-web-t02";
              ip = 212;
            }
            {
              name = "irra-web-t01";
              ip = 151;
            }
          ])
          // (createIndiServers 128 [
            {
              name = "irbo-web-t01";
              ip = 211;
            }
            {
              name = "irbo-web-t02";
              ip = 212;
            }
            {
              name = "irbo-db-t01";
              ip = 221;
            }
            {
              name = "irbo-db-t02";
              ip = 222;
            }
            {
              name = "irbo-web-p01";
              ip = 51;
            }
            {
              name = "irbo-web-p02";
              ip = 52;
            }
            {
              name = "irbo-dbm-p01";
              ip = 81;
            }
            {
              name = "irbo-dbs-p01";
              ip = 82;
            }
          ])
          // {
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
      ../../modules/home
    ];

    modules.home = {
      general = {
        keymap = "us-umlaute";
        theme = {
          name = "terminal";
          font = "JetBrainsMono";
          transparent = true;
          colorscheme = {
            name = "tokyonight";
            nvimName = "tokyonight"; # WARN: This is a temporary fix
            zellijName = "tokyo-night-storm";
          };
        };
      };

      programs = {
        emacs.enable = false;
        ghostty.enable = false;
        kitty.enable = true;
        neovim.enable = true;
        nushell.enable = false;
        themer.enable = false;
        tmux.enable = true;
        yazi.enable = true;
        zoxide.enable = true;
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
