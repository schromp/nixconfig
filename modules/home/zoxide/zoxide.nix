{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.programs.zoxide;
  zsh = config.modules.home.programs.zsh.enable;
in {
  options.modules.home.programs.zoxide.enable = lib.mkEnableOption "Enable zoxide";

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration =
        if zsh
        then true
        else false;
    };
  };
}
