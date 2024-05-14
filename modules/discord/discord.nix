{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.discord;
in {
  home = {
    options.modules.programs.discord = {
      enable = lib.mkEnableOption "Enable Discord";
      aarpc = lib.mkEnableOption "Enable aarpc for discord rich presence";
    };

    config = lib.mkIf cfg.enable (lib.mkMerge [
      {
        home-manager.users.${username} = {
          home.packages = with pkgs; [
            webcord-vencord
            armcord
            vesktop
            # (vesktop.overrideAttrs (old: {
            #   src = fetchFromGitHub {
            #     owner = "Vencord";
            #     repo = "Vesktop";
            #     rev = "3fdc55a47e48d0bfd0bfa5cc9f9f566a57d99417";
            #     hash = "sha256-K6+G82yIQgi5NhYOobDYlqvPzFhPSg4NDdmPy8PHwVI=";
            #   };
            # }))
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
  };
}
