{
  config,
  pkgs,
  lib,
  options,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.emacs;
in {
  options.modules.programs.emacs = {
    enable = lib.mkEnableOption "Enable emacs";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.emacs = {
        enable = true;
        # extraPackages = [ pkgs.emacsPackages.evil ];
      };
    };
  };
}
