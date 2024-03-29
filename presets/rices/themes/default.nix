{lib, ...}:
with lib; {
  imports = [
    ./catppuccin_mocha.nix
    ./catppuccin_latte.nix
    ./onedark.nix
  ];

  # GOAL: have these options for creating themes
  # When selecting theme: options.themes.select = ["name"];
  options.presets.themes = {
    name = mkOption {
      type = types.enum ["none" "catppuccin-mocha" "catppuccin-latte" "onedark"];
      description = "The theme that should be applied to programs specified in apply";
      default = "none";
    };

    kind = mkOption {
      type = types.enum ["dark" "light"];
      description = "True if the theme is a darktheme";
    };

    # FIX:
    colors = mkOption {
      type = with types; attrsOf str;
    };

    cursor = mkOption {
      type = with types; submodule {
        options = {
          name = mkOption {
            type = str;
          };
          package = mkOption {
            type = package;
          };
        };
      };
    };

    theme = mkOption {
      type = with types; submodule {
        options = {
          name = mkOption {
            type = str;
          };
          package = mkOption {
            type = package;
          };
        };
      };
    };

    icon = mkOption {
      type = with types; submodule {
        options = {
          name = mkOption {
            type = str;
          };
          package = mkOption {
            type = package;
          };
        };
      };
    };

  };
}
