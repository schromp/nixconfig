{lib, ...}:
with lib; {
  options.modules.user = {
    # Here we define global user choices

    homeManager.enabled = mkEnableOption "Enable home-manager modules";

    username = mkOption {
      type = types.str;
      description = ''
        Default user for the device. Is also used in Home-Manager
      '';
    };

    repoDirectory = mkOption {
      type = types.str;
      description = "Where the repo of this config is saved";
    };

    keymap = mkOption {
      type = types.enum ["us" "us-umlaute"];
      default = ["us"];
      description = ''Set xkb layout'';
    };

    displayManager = mkOption {
      type = types.enum ["sddm"];
      description = ''Choose your display manager'';
    };

    displayServerProtocol = mkOption {
      type = types.enum ["x11" "wayland"];
      description = ''
        Choose the display server protocol
      '';
    };

    desktopEnvironment = mkOption {
      type = types.enum ["hyprland" "i3" "gnome"];
      description = ''
        Choose your desktop environment
      '';
    };

    monitor = mkOption {
      type = with types;
        submodule {
          options = {
            name = mkOption {
              type = str;
            };
            resolution = mkOption {
              type = str;
            };
            refreshRate = mkOption {
              type = str;
            };
            scale = mkOption {
              type = str;
            };
            position = mkOption {
              type = str;
            };
          };
        };
    };

    terminal = mkOption {
      type = types.enum ["kitty"];
      description = ''Choose your terminal emulator'';
    };

    browser = mkOption {
      type = types.enum ["firefox" "qutebrowser" "floorp"];
      description = ''Choose your browser'';
    };

    fileManager = mkOption {
      type = types.enum ["pcmanfm"];
      description = ''Choose your file manager'';
    };

    screenshotTool = mkOption {
      type = types.enum [ "grimblast" "satty"];
      description = "Which screenshot tool to use";
    };

    appRunner = mkOption {
      type = types.enum ["fuzzel" "wofi" "anyrun"];
      default = "fuzzel";
      description = ''
        Select the App Runner Hyprland should use.
      '';
      example = "fuzzel";
    };
  };
}
