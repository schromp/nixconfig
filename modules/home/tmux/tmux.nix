{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.home.programs.tmux;
in {
  options.modules.home.programs.tmux = {
    enable = lib.mkEnableOption "Enable tmux";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [tmuxifier];
    programs.tmux = {
      enable = true;
      prefix = "C-a";
      baseIndex = 1;
      mouse = true;
      keyMode = "vi";
      tmuxinator.enable = true;
      plugins = [
        {
          plugin = pkgs.tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
        {
          plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
        }
        {
          plugin = pkgs.tmuxPlugins.sensible;
        }
        {
          plugin = pkgs.tmuxPlugins.resurrect;
        }
        {
          plugin = inputs.tmux-sessionx.packages.${pkgs.system}.default;
          extraConfig = ''
            set -g @sessionx-zoxide-mode 'on'
          '';
        }
        {
          plugin = pkgs.tmuxPlugins.tmux-thumbs;
        }
        {
          plugin = pkgs.tmuxPlugins.tmux-fzf;
        }
      ];

      extraConfig = ''
        # set -g default-command "\$\{SHELL}"

        setw -g mode-keys vi

        set -g base-index 1
        setw -g pane-base-index 1
        set -g renumber-windows on

        set-option -g status-position top

        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        bind-key -n C-S-Left swap-window -t -1
        bind-key -n C-S-Right swap-window -t +1

        bind-key y display-popup -w 85% -h 90% -E "yazi"

        # --- Status line ---
        set-option -g status-left ""
        set-option -g status-right "[#S]"

        setw -g window-status-format ' #I-#W '
        setw -g window-status-current-format '[#I-#W]'

        set-option -g status-interval 1
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{b:pane_current_path}'

        ${
          if config.modules.home.programs.themer.enable
          then ''source-file ~/.config/tmux/themer.conf''
          else ""
        }
      '';
    };
  };
}
