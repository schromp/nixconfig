{ config, lib, ... }: with lib; let
  username = config.modules.user.username;
  cfg = config.presets.themes;
  colors = cfg.colors;

in {

  config = mkIf (cfg.name != "none") {
    home-manager.users.${username} = {
      programs.fuzzel.settings = {
        background = colors.base00;
        text = colors.base05;
        match = colors.base08;
        selection = colors.base09;
        selection-match = colors.base0A;
      };
    };
  };

}
