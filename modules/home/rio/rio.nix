{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.rio;
in {
  options.modules.home.programs.rio = {
    enable = lib.mkEnableOption "Enable rio terminal";
  };

  config = lib.mkIf cfg.enable {
    programs.rio = {
      enable = true;
      # settings = builtins.readFile ./rio.toml;
      settings = {
        theme = "dracula";
        cursor = {
          shape = "beam";
        };
        editor = {
          program = "nvim";
          args = [];
        };
        window = {
          opacity = 0.8;
        };
        navigation = {
          mode = "bookmark";
          hide-if-single = false;
          use-current-path = true;
        };
        fonts = {
          size = 20;
          regular = {
            family = "Cascadia Code";
            style = "Normal";
          };
        };
      };
    };

    xdg.configFile."rio/themes/dracula.toml".text = builtins.readFile ./dracula-rio.toml;
  };
}
