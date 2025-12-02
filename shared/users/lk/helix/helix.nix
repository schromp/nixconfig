{config, ...}: {
  home.file."config/helix/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink /home/lk/repos/nixconfig/shared/users/lk/helix/config.toml;
}
