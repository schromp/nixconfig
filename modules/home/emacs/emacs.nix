{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.emacs;
in {
  options.modules.home.programs.emacs = {
    enable = lib.mkEnableOption "Enable emacs";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      fd
      tree-sitter
    ];

    programs.emacs = {
      enable = true;
    };

    services.emacs = {
      enable = true;
      extraOptions = [ "-q" "-l" "~/repos/nixconfig/modules/home/emacs/init.el" ];
    };
  };
}
