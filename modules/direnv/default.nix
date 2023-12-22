{
  lib,
  config,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.direnv;
in {
  options.modules.programs.direnv.enable = mkEnableOption "Enable direnv";

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;
      # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
      # programs.direnv.nix-direnv.enableFlakes = true;
    };
  };
}
