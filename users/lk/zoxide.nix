{
  config,
  ...
}:
let
  zsh = config.programs.zsh.enable;
in
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = if zsh then true else false;
  };
}
