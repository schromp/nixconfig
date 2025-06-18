{
  config,
  lib,
  pkgs,
  sysConfig,
  ...
}: let
  cfg = config.modules.home.programs.zsh;
  colors = config.modules.home.general.theme.colorscheme.colors;
  hostname = sysConfig.modules.system.general.hostname;
in {
  options.modules.home.programs.zsh = {
    enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fzf
      eza
      killall
    ];

    programs.fzf.enableZshIntegration = true;

    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      autosuggestion.enable = true;
      # enableAutosuggestions = true;
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
        "cat" = "${lib.getExe pkgs.bat}";

        "update-switch" = "sudo nixos-rebuild switch --flake .#${hostname}";
        "update-test" = "sudo nixos-rebuild test --flake .#${hostname}";
        "update-check" = "nix flake check";
      };
      oh-my-zsh = {
        enable = true;
        plugins = ["sudo" "git"];
        extraConfig = ''
          DISABLE_MAGIC_FUNCTIONS="true" # This fixes slow pasting

          # --- Prompt ---
          # Autoload zsh's `add-zsh-hook` and `vcs_info` functions
          # (-U autoload w/o substition, -z use zsh style)
          autoload -Uz add-zsh-hook vcs_info

          # Set prompt substitution so we can use the vcs_info_message variable
          setopt prompt_subst

          COL_NAME="${colors.base09}"
          COL_DIR="${colors.base0A}"
          COL_GIT="${colors.base0E}"

          NEWLINE=$'\n'

          # add-zsh-hook precmd getColors
          # add-zsh-hook precmd vcs_info
          precmd_functions+=(vcs_info)

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


          PROMPT=' ''${NEWLINE}%F{#$COL_NAME}%n%f %F{#$COL_DIR}%3~%f %F{#$COL_GIT}''${vcs_info_msg_0_}%f %(?..%B%F{red}(%?%)%f%b)''${NEWLINE}> '

          ${
            if hostname == "M65L7Q9X32"
            then ''export SSH_AUTH_SOCK="$HOME/.ssh/agent"''
            else ""
          }

          ${
            if pkgs.system == "aarch64-darwin"
            then ''
              eval $(/opt/homebrew/bin/brew shellenv)
              export SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.dylib
            ''
            else ''''
          }
        '';
      };
    };
  };
}
