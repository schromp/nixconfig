{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  user = config.modules.user.username;
  cfg = config.modules.programs.tmux;
in {
  options.modules.programs.tmux = {
    enable = mkEnableOption "Enable tmux";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        mouse = true;
        keyMode = "vi";
        tmuxinator.enable = true;
        plugins = with pkgs; [
          {
            plugin = tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '60' # minutes
            '';
          }
          {
            plugin = tmuxPlugins.vim-tmux-navigator;
          }
          {
            plugin = tmuxPlugins.sensible;
          }
          {
            plugin = tmuxPlugins.resurrect;
          }
        ];

        extraConfig = ''
          set -g default-command "\$\{SHELL}"

          setw -g mode-keys vi

          set -g base-index 1
          setw -g pane-base-index 1

          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R
        '';
      };
    };
  };
}
