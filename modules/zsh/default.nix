{
  config,
  lib,
  pkgs,
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
    environment.systemPackages = with pkgs; [fzf eza killall];

    programs.zsh = {
      enable = true;
    };

    programs.fzf.keybindings = true;

    home-manager.users.${username} = {
      # imports = [./starship.nix];
      programs.zsh = {
        enable = true;
        dotDir = ".config/zsh";
        # autosuggestion.enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
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
          ls = "eza --icons=auto";
          hyprgame-off = "hyprctl keyword bind SUPER,Q,killactive";
          hyprgame-on = "hyprctl keyword unbind SUPER,Q";

          "update-switch" = "sudo nixos-rebuild switch --flake .#${config.modules.system.hostname}";
          "update-test" = "sudo nixos-rebuild test --flake .#${config.modules.system.hostname}";
          "update-check" = "nix flake check";
        };
        oh-my-zsh = {
          enable = true;
          plugins = ["sudo" "web-search" "git"];
          extraConfig = ''
            DISABLE_MAGIC_FUNCTIONS="true" # This fixes slow pasting

            # --- Prompt ---
            # Autoload zsh's `add-zsh-hook` and `vcs_info` functions
            # (-U autoload w/o substition, -z use zsh style)
            autoload -Uz add-zsh-hook vcs_info

            # Set prompt substitution so we can use the vcs_info_message variable
            setopt prompt_subst



            # Run the `vcs_info` hook to grab git info before displaying the prompt
            add-zsh-hook precmd vcs_info


            # Style the vcs_info message
            zstyle ':vcs_info:*' enable git
            zstyle ':vcs_info:git*' formats '%b%u%c'
            # Format when the repo is in an action (merge, rebase, etc)
            zstyle ':vcs_info:git*' actionformats '%F{14}⏱ %*%f'
            zstyle ':vcs_info:git*' unstagedstr '*'
            zstyle ':vcs_info:git*' stagedstr '+'
            # This enables %u and %c (unstaged/staged changes) to work,
            # but can be slow on large repos
            zstyle ':vcs_info:*:*' check-for-changes true

            COL_NAME="cba6f7"
            COL_DIR="f2cdcd"
            COL_GIT="fab387"

            NEWLINE=$'\n'
            source ~/.config/zsh/prompt.sh

            function getColors() {
              unset COL_NAME COL_DIR COL_GIT
              source ~/.config/zsh/prompt.sh
            }
            add-zsh-hook precmd getColors


            PROMPT="''${NEWLINE}%F{#$COL_NAME}%n%f %F{#$COL_DIR}%3~%f %F{#$COL_GIT}''${vcs_info_msg_0_}%f %(?..%B%F{red}(%?%)%f%b)''${NEWLINE}> "

            ${
              if config.modules.programs.themer.enable
              then "source ~/.config/zsh/prompt.sh"
              else ""
            }
          '';
        };
      };
    };
  };
}
