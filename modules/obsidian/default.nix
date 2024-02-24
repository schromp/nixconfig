{
  config,
  lib,
  pkgs,
  nixpkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.obsidian;
in {
  options.modules.programs.obsidian.enable = mkEnableOption "Enable obsidian";

  config = mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";
    environment.systemPackages = with pkgs; [ obsidian ];
  };
}
