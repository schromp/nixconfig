{
  config,
  lib,
  ...
}: let
  cfg = config.modules.programs.emacs;
in {
  options.modules.programs.emacs = {
    enable = lib.mkEnableOption "Enable emacs";
  };

  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      # extraPackages = [ pkgs.emacsPackages.evil ];
    };
  };
}
