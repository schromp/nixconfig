{ osConfig, config, lib, ... }:
let
  comp = osConfig.modules.local.system.compositor;
in
{
  config = lib.mkIf (comp == "niri") {
    home.file.".config/niri/config.toml".source = config.lib.file.mkOutOfStoreSymlink /home/lk/repos/nixconfig/modules/home/niri/config.toml;
  };
}
