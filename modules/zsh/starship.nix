{
  config,
  inputs,
  ...
}: let
  rosewater = "#f4dbd6";
  flamingo = "#f0c6c6";
  pink = "#f5bde6";
  mauve = "#c6a0f6";
  red = "#ed8796";
  maroon = "#ee99a0";
  peach = "#f5a97f";
  yellow = "#eed49f";
  green = "#a6da95";
  teal = "#8bd5ca";
  sky = "#91d7e3";
  sapphire = "#7dc4e4";
  blue = "#8aadf4";
  lavender = "#b7bdf8";
  text = "#cad3f5";
  subtext1 = "#b8c0e0";
  subtext0 = "#a5adcb";
  overlay2 = "#939ab7";
  overlay1 = "#8087a2";
  overlay0 = "#6e738d";
  surface2 = "#5b6078";
  surface1 = "#494d64";
  surface0 = "#363a4f";
  base = "#24273a";
  mantle = "#1e2030";
  crust = "#181926";
in {
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [](${pink})$username[](bg:${mauve} fg:${pink})$directory[](${mauve}) $git_branch$git_state$git_status $cmd_duration$line_break$character
      '';

      os = {
        disabled = false;
        style = "bg:${pink} fg:${base}";
      };

      username = {
        show_always = true;
        style_user = "bg:${pink} fg:${base}";
        format = "[$user ]($style)";
      };

      directory = {
        style = "bg:${mauve} fg:${base}";
        format = "[ $path]($style)[$read_only]($read_only_style)";
        trunctation_length = 3;
      };

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };

      git_branch = {
        format = "[](${blue})[$symbol $branch ]($style)[](bg:${teal} fg:${blue})";
        symbol = "";
        style = "bg:${blue} fg:${base}";
      };

      git_status = {
        format = "[[( $conflicted$untracked$modified$staged$renamed$deleted)]($style) ($ahead_behind$stashed)]($style)[](${teal})";
        style = "bg:${teal} fg:${base}";
        conflicted = "=";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
        stashed = "≡";
      };

      git_state = {
        # format = "[$state$progress_current/$progress_total]($style)"; # TODO:
        format = "[$state( $progress_current/$progress_total)]($style)";
        # style = "${blue}";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
    };
  };
}
