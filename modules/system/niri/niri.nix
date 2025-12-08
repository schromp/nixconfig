{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  comp = config.modules.local.system.compositor;
in
{
  config = lib.mkIf (comp == "niri") {
    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      # xwayland-satellite
      (pkgs.callPackage "${inputs.nixpkgs-xwayland-satellite}/pkgs/by-name/xw/xwayland-satellite/package.nix" {})
    ];
  };
}
