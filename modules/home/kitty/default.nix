{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.programs.kitty;
  configFile = builtins.readFile ./kitty.conf;
  customThemes = ["none" "kanagawa" "catppuccin-macchiato" "onedark"];
in {
  options.modules.home.programs.kitty = {
    enable = lib.mkEnableOption "Enable Kitty";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "none";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "kitty/kanagawa.conf".source = ./kanagawa.conf;
      "kitty/onedark.conf".source = ./onedark.conf;
      "kitty/catppuccin-macchiato.conf".source = ./catppuccin-macchiato.conf;
    };
    programs.kitty = {
      enable = true;
      # theme = mkIf (!builtins.elem cfg.theme customThemes) cfg.theme;
      shellIntegration.enableZshIntegration = true;
      extraConfig =
        configFile
        + ''
          include ./theme.conf
        '';
    };
  };
}
