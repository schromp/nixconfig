{
  lib,
  config,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.kitty;
  configFile = builtins.readFile ./kitty.conf;
  customThemes = ["none" "kanagawa" "catppuccin-macchiato" "onedark"];
in {
  options.modules.programs.kitty = {
    enable = lib.mkEnableOption "Enable Kitty";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "none";
    };
  };

  home = {
    config = lib.mkIf cfg.enable {
      home-manager.users.${username} = {
        xdg.configFile = {
          "kitty/kanagawa.conf".source = ./kanagawa.conf;
          "kitty/onedark.conf".source = ./onedark.conf;
          "kitty/catppuccin-macchiato.conf".source = ./catppuccin-macchiato.conf;
        };
        programs.kitty = {
          enable = true;
          # theme = mkIf (!builtins.elem cfg.theme customThemes) cfg.theme;
          extraConfig =
            configFile
            + ''
              include ./theme.conf
            '';
        };
      };
    };
  };
}
