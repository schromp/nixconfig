{
  lib,
  config,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.kitty;
  configFile = builtins.readFile ./kitty.conf;
  customThemes = ["none" "kanagawa" "catppuccin-macchiato" "onedark"];
in {
  options.modules.programs.kitty = {
    enable = mkEnableOption "Enable Kitty";
    theme = mkOption {
      type = types.str;
      default = "none";
    };
  };

  config = mkIf cfg.enable {
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
}
