{
  pkgs,
  config,
  ...
}:
{
  home.packages = [
    (if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then pkgs.opencode else pkgs.opencode)
    pkgs.mcp-grafana
  ];

  xdg.configFile."opencode/opencode.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/opencode/opencode.jsonc";
}
