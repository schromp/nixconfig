{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.walker;
in {
  options.modules.home.programs.walker = {
    enable = lib.mkEnableOption "Enable walker";
  };

  imports = [inputs.walker.homeManagerModules.default];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [libqalculate];

    programs.walker = {
      enable = true;
      config = {
        builtins = {
          runner = {
            prefix = "$";
            eager_loading = true;
            weight = 5;
            icon = "utilities-terminal";
            name = "runner";
            placeholder = "Runner";
            typeahead = true;
            history = true;
            generic_entry = false;
            refresh = true;
            use_fd = false;
          };
          websearch = {
            prefix = "?";
            entries = [
              {
                name = "DuckDuckGo";
                url = "https://duckduckgo.com/?q=%TERM%";
              }
            ];
          };
          calc = {
            require_number = true;
            weight = 5;
            name = "calc";
            icon = "accessories-calculator";
            placeholder = "Calculator";
            min_chars = 4;
          };
          finder = {
            prefix = "~";
          };
        };
      };
    };
  };
}
