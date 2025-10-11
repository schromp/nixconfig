{
  lib,
  config,
  ...
}:
let
  comp = config.modules.local.system.compositor;
in
{
  config = lib.mkIf (comp == "niri") {
    programs.niri.enable = true;
  };
}
