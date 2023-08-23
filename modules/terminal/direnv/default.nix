{lib, config, ...}:
with lib; let
  cfg = config.modules.terminal.direnv;
in {
  options.modules.terminal.direnv.enable = mkEnableOption "Enable direnv";

  config = mkIf cfg.enable {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
    # programs.direnv.nix-direnv.enableFlakes = true;
  };
}
