{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.discord;
in {
  options.modules.home.programs.discord = {
    enable = lib.mkEnableOption "Enable Discord";
    aarpc = lib.mkEnableOption "Enable aarpc for discord rich presence";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = with pkgs; [
        vesktop
        discord-canary
      ];
    }
    (lib.mkIf cfg.aarpc {
      home.packages = [
        inputs.arrpc.packages.${pkgs.system}.arrpc
      ];
    })
  ]);
}
