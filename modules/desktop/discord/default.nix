{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.discord;

in {
  options.modules.programs.discord = {
    enable = mkEnableOption "Enable Discord";
    aarpc = mkEnableOption "Enable aarpc for discord rich presence";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home-manager.users.${username} = {
        home.packages = with pkgs; [webcord-vencord];
      };
    }
    (mkIf cfg.aarpc {
      home-manager.users.${username} = {
        home.packages = [
          inputs.arrpc.packages.${pkgs.system}.arrpc
        ];
      };
    })
  ]);
}
