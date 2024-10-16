{
  inputs,
  config,
  options,
  pkgs,
  lib,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.yazi;
in {
  options.modules.programs.yazi = {
    enable = lib.mkEnableOption "Enable Yazi terminal file manager";
    macos = lib.mkEnableOption "Use macos package";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        package = lib.mkIf cfg.macos inputs.nixpkgs-unstable.legacyPackages."aarch64-darwin".yazi;
      };
    };
  };
}
