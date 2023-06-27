{lib, config, inputs, pkgs, ...}:
with lib; let
  username = import ../../username.nix;
  cfg = config.modules.gaming.prismLauncher;
in {
  options.modules.gaming.prismLauncher.enable = mkEnableOption "Enable PrismLauncher";

  config = mkIf cfg.enable {
    nixpkgs.config.overlay = with inputs; [
      prismlauncher.overlay
    ];

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        prismlauncher
      ];
    };
  };
}
