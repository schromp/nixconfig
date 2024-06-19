{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  username = config.modules.user.username;
  cfg = config.modules.programs.discord;
in {
  options.modules.programs.discord = {
    enable = lib.mkEnableOption "Enable Discord";
    aarpc = lib.mkEnableOption "Enable aarpc for discord rich presence";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          vesktop
          # discord
          # webcord
        ];
      };
    }
    (lib.mkIf cfg.aarpc {
      home-manager.users.${username} = {
        home.packages = [
          inputs.arrpc.packages.${pkgs.system}.arrpc
        ];
      };
    })
  ]);
}
