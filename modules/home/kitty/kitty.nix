{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.programs.kitty;
  configFile = builtins.readFile ./kitty.conf;
  customThemes = ["none" "kanagawa" "catppuccin-macchiato" "onedark"];
  themerEnabled = config.modules.home.programs.themer.enable;
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
      shellIntegration.enableZshIntegration = true;
      extraConfig =
        configFile
        + (
          if themerEnabled
          then ''
            include ./theme.conf
          ''
          else ""
        );
    };
  };
}
