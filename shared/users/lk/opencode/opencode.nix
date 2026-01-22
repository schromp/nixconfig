{pkgs, config, ...}: {
  home.packages = [
    pkgs.opencode
  ];

  xdg.configFile."opencode/opencode.jsonc".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/opencode/opencode.jsonc";
}
