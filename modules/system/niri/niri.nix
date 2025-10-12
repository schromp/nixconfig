{
  lib,
  config,
  pkgs,
  ...
}:
let
  comp = config.modules.local.system.compositor;
in
{
  config = lib.mkIf (comp == "niri") {
    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };
}
