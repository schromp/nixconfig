{
  lib,
  config,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.direnv;
in {
  home = {
    options.modules.programs.direnv.enable = lib.mkEnableOption "Enable direnv";

    config = lib.mkIf cfg.enable {
      home-manager.users.${username} = {
        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;
        # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
        # programs.direnv.nix-direnv.enableFlakes = true;
      };
    };
  };
}
