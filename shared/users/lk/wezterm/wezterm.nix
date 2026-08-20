{
  config,
  ...
}:
{
  programs.wezterm = {
    enable = true;
  };

  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/wezterm/wezterm.lua";
}
