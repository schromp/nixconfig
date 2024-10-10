{lib, ...}:
with lib; {
  options.modules.home.general = {
    # Here we define global user choicesuser

    username = mkOption {
      type = types.str;
      description = ''
        Default user for the device. Is also used in Home-Manager
      '';
    };

    keymap = mkOption {
      type = types.enum ["us-umlaute"];
    };

    desktop = lib.mkOption {
      type = with types;
        listOf (submodule {
          defaultTerminal = mkOption {
            type = types.enum ["kitty" "wezterm" "rio"];
            description = ''Choose your terminal emulator'';
          };
          defaultBrowser = mkOption {
            type = types.enum ["firefox" "qutebrowser" "floorp"];
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
            type = types.enum ["fuzzel" "wofi" "anyrun" "tofi" "walker"];
            default = "fuzzel";
            description = ''
              Select the App Runner Hyprland should use.
            '';
            example = "fuzzel";
          };
        });
    };
  };
}
