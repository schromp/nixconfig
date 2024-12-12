{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.programs.kitty;
  configFile = builtins.readFile ./kitty.conf;
  theme = config.modules.home.general.theme;
  colors = theme.colorscheme.colors;
in {
  options.modules.home.programs.kitty = {
    enable = lib.mkEnableOption "Enable Kitty";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "none";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      extraConfig = ''
        font_family ${theme.font}
        font_size 14.0

        cursor_blink_interval 0
        open_url_with_default
        enable_audio_bell no
        single_window_margin_width 1
        confirm_os_window_close 0
        shell nu

        background #${colors.base00}
        foreground #${colors.base05}
        selection_background #${colors.base05}
        selection_foreground #${colors.base00}
        url_color #${colors.base04}
        cursor #${colors.base05}
        cursor_text_color #${colors.base00}
        active_border_color #${colors.base03}
        inactive_border_color #${colors.base01}
        active_tab_background #${colors.base00}
        active_tab_foreground #${colors.base05}
        inactive_tab_background #${colors.base01}
        inactive_tab_foreground #${colors.base04}
        tab_bar_background #${colors.base01}
        wayland_titlebar_color #${colors.base00}
        macos_titlebar_color #${colors.base00}

        # normal
        color0 #${colors.base00}
        color1 #${colors.base08}
        color2 #${colors.base0B}
        color3 #${colors.base0A}
        color4 #${colors.base0D}
        color5 #${colors.base0E}
        color6 #${colors.base0C}
        color7 #${colors.base05}

        # bright
        color8 #${colors.base03}
        color9 #${colors.base09}
        color10 #${colors.base01}
        color11 #${colors.base02}
        color12 #${colors.base04}
        color13 #${colors.base06}
        color14 #${colors.base0F}
        color15 #${colors.base07}
      '';
    };
  };
}
