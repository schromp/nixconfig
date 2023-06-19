{lib, inputs, ...}:
with lib; let
  cfg = options.modules.gaming.prismLauncher;
in {
  cfg.enable = mkEnableOption "Enable PrismLauncher";

  config.prismLauncher = mkIf cfg.enable {
    nixpkgs.config.overlay = with inputs; [
      prismlauncher.overlay
    ];

    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
