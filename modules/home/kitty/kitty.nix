{
  lib,
  config,
  pkgs,
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
        cursor_trail 1
        open_url_with_default
        enable_audio_bell no
        single_window_margin_width 1
        confirm_os_window_close 0
        shell zsh
        tab_bar_min_tabs 2
        macos_option_as_alt yes

        # Keybindings

        # map ctrl+h neighboring_window left
        # map ctrl+j neighboring_window down
        # map ctrl+k neighboring_window up
        # map ctrl+l neighboring_window right
        #
        # map --new-mode mw ctrl+a --on-action end
        #
        # map --mode mw n combine : new_window : pop_keyboard_mode
        # map --mode mw t combine : new_tab : pop_keyboard_mode
        # map --mode mw r combine : set_tab_title " " : pop_keyboard_mode
        # map --mode mw x close_window
        #
        # map --mode mw o next_layout
        #
        # map --mode mw 1 combine : goto_tab 1 : pop_keyboard_mode
        # map --mode mw 2 combine : goto_tab 2 : pop_keyboard_mode
        # map --mode mw 3 combine : goto_tab 3 : pop_keyboard_mode
        # map --mode mw 4 combine : goto_tab 4 : pop_keyboard_mode
        # map --mode mw 5 combine : goto_tab 5 : pop_keyboard_mode
        # map --mode mw 6 combine : goto_tab 6 : pop_keyboard_mode
        # map --mode mw 7 combine : goto_tab 7 : pop_keyboard_mode
        # map --mode mw 8 combine : goto_tab 8 : pop_keyboard_mode
        # map --mode mw 9 combine : goto_tab 9 : pop_keyboard_mode
        # map --mode mw 0 combine : goto_tab 10 : pop_keyboard_mode
        #
        # # Move the active window in the indicated direction
        # map --mode mw h move_window left
        # map --mode mw j move_window down
        # map --mode mw k move_window up
        # map --mode mw l move_window right
        #
        # # Resize the active window
        # map --mode mw shift+h resize_window narrower
        # map --mode mw shift+l resize_window wider
        # map --mode mw shift+k resize_window taller
        # map --mode mw shift+j resize_window shorter

        # Scrolling submode
        # map --mode mw --new-mode scr
        # map --mode scr j scroll_line_down
        # map --mode scr k scroll_line_up
        # map --mode scr p scroll_to_prompt -1
        # map --mode scr n scroll_to_prompt 1

        # Exit the manage window mode
        # map --mode mw esc pop_keyboard_mode

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
