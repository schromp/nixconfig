{
  config,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.zsh;
in {
  options.modules.programs.zsh = {
    enable = mkEnableOption "Enable zsh";
  };

  config = mkIf cfg.enable {

    # for zsh autocompletions on systemlevel
    environment.pathsToLink = ["/share/zsh"];
    programs.zsh.enable = true;

    home-manager.users.${username} = {
      imports = [./starship.nix];
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

          eval "$(direnv hook zsh)"
        '';
        shellAliases = {
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          "....." = "cd ../../../..";
          lg = "lazygit";
          rn = "ranger";
        };
        oh-my-zsh = {
          enable = true;
          plugins = ["sudo" "web-search" "git" "tmux" "ssh-agent"];
        };
      };
    };
  };
}
