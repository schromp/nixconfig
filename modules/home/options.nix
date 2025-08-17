{lib, ...}:
with lib; {
  options.modules.home.general = {
    keymap = lib.mkOption {
      type = lib.types.enum ["us-umlaute"];
    };

    desktop = lib.mkOption {
      type = with types;
        submodule {
          options = {
            defaultTerminal = mkOption {
              type = types.enum ["kitty" "wezterm" "rio"];
              description = ''Choose your terminal emulator'';
            };
            defaultBrowser = mkOption {
              type = types.enum ["firefox" "qutebrowser" "floorp" "zen"];
              description = ''Choose your browser'';
            };

            defaultFileManager = mkOption {
              type = types.enum ["pcmanfm"];
              description = ''Choose your file manager'';
            };

            defaultScreenshotTool = mkOption {
              type = types.enum ["grimblast" "satty" "swappy"];
              description = "Which screenshot tool to use";
            };

            defaultAppRunner = mkOption {
              type = types.enum ["fuzzel" "wofi" "anyrun" "tofi" "walker" "vicinae"];
              default = "fuzzel";
              description = ''
                Select the App Runner Hyprland should use.
              '';
              example = "fuzzel";
            };
          };
        };
    };
  };
}
