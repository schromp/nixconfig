{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.wezterm;
  theme = config.modules.home.general.theme;
  colors = theme.colorscheme.colors;
in {
  options.modules.home.programs.wezterm = {
    enable = lib.mkEnableOption "Enable Wezterm";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require("wezterm")
        local config = require "extras"

        config.colors = wezterm.color.load_base16_scheme("${config.xdg.configHome}/wezterm/theme.yaml")
        ${
          if theme.transparent
          then "config.window_background_opacity = 0.8"
          else ""
        }

        return config
      '';
      # enableZshIntegration = false;
    };

    xdg.configFile."wezterm/extras.lua".text = builtins.readFile ./wezterm.lua;
    xdg.configFile."wezterm/theme.yaml".text = ''
      scheme: ${theme.name}
      author: "None"
      base00: "${colors.base00}" #background
      base01: "${colors.base01}"
      base02: "${colors.base02}"
      base03: "${colors.base03}"
      base04: "${colors.base04}"
      base05: "${colors.base05}" #foreground
      base06: "${colors.base06}"
      base07: "${colors.base07}"
      base08: "${colors.base08}"
      base09: "${colors.base09}"
      base0A: "${colors.base0A}"
      base0B: "${colors.base0B}"
      base0C: "${colors.base0C}"
      base0D: "${colors.base0D}"
      base0E: "${colors.base0E}"
      base0F: "${colors.base0F}"
    '';
  };
}
