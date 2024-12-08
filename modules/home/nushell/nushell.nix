{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.nushell;
in {
  options.modules.home.programs.nushell = {
    enable = lib.mkEnableOption "Enable nushell";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nushell
    ];

    xdg.configFile."nushell/config.nu".text = builtins.readFile ./config.nu;
  };
}
