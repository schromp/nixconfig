{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.terminal.tmux;
in {
  options.modules.terminal.tmux = {
    enable = mkEnableOption "Enable tmux";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.tmux = {
        enable = true;
        clock24 = true;
        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          sensible
          yank
          {
            plugin = dracula;
            extraConfig = ''
              set -g @dracula-show-battery false
              set -g @dracula-show-powerline true
              set -g @dracula-refresh-rate 10

              set -g @dracula-ping-server "google.com"
              set -g @dracula-ping-rate 5

              set -g @dracula-show-location false
            '';
          }
        ];
        extraConfig = ''
          set -g default-command "\$\{SHELL}"

          set -g mouse on

          setw -g mode-keys vi
          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R

        '';
      };
    };
  };
}
