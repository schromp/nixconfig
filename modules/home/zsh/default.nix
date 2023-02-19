{ config, inputs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    completionInit = ''
      autoload -U compinit
      compinit
      
      # Use vim keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char
    '';
    shellAliases = {
      ".." = "cd ..";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "sudo" "web-search" "git" ];
    };
  };
}

