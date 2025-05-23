{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.programs.direnv;
in {
  options.modules.home.programs.direnv.enable = lib.mkEnableOption "Enable direnv";

  config = lib.mkIf cfg.enable {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
    # programs.direnv.nix-direnv.enableFlakes = true;
  };
}
