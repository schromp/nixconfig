{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = options.modules.terminal.direnv;
in {
  cfg.enable = mkEnableOption "Enable direnv";

  config = {
    direnv = mkIf cfg.enable {
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;
      # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
      # programs.direnv.nix-direnv.enableFlakes = true;
    };
  };
}
