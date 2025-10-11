{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    package = lib.mkIf (
      pkgs.system == "aarch64-darwin"
    ) inputs.nixpkgs-unstable.legacyPackages."aarch64-darwin".yazi;
  };
}
