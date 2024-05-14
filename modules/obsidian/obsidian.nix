{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.obsidian;
in {
  # options.modules.programs.obsidian.enable = lib.mkEnableOption "Enable obsidian";
  #
  # system = {
  #   config = lib.mkIf cfg.enable {
  #     nixpkgs.config.permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";
  #     environment.systemPackages = with pkgs; [obsidian];
  #   };
  # };
}
