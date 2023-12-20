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

    terminal = mkOption {
      type = types.enum ["kitty"];
      description = ''Choose your terminal emulator'';
    };

    browser = mkOption {
      type = types.enum ["firefox"];
      description = ''Choose your browser'';
    };

    fileManager = mkOption {
      type = types.enum ["pcmanfm"];
      description = ''Choose your file manager'';
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
