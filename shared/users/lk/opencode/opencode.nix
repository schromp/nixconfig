{pkgs, config, ...}: {
  home.packages = [
    (if pkgs.system == "aarch64-darwin" then pkgs.opencode else pkgs.opencode)
  ];

  xdg.configFile."opencode/opencode.jsonc".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/opencode/opencode.jsonc";
}
