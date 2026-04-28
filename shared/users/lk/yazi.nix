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
      pkgs.stdenv.hostPlatform.system == "aarch64-darwin"
    ) inputs.nixpkgs.legacyPackages."aarch64-darwin".yazi;
    shellWrapperName = "y";
  };
}
