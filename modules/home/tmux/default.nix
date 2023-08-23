{ config, inputs, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    shell = "\${pkgs.zsh}/bin/zsh"; # TODO:
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
        '';
      }
    ];
    extraConfig = ''
      set -g mouse on

      setw -g mode-keys vi
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

    '';
  };
}
