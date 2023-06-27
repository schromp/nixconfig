{ config, lib, ...}:
with lib; let
  cfg = config.modules.test123;
in {
  
  options.modules.test123.enable = mkEnableOption "test";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };

}
