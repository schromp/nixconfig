{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.yazi;
in {
  options.modules.home.programs.yazi = {
    enable = lib.mkEnableOption "Enable Yazi terminal file manager";
    macos = lib.mkEnableOption "Use macos package";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      package = lib.mkIf cfg.macos inputs.nixpkgs-unstable.legacyPackages."aarch64-darwin".yazi;
    };
  };
}
