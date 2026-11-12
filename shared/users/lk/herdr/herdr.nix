{
  config,
  pkgs,
  inputs,
  ...
}:
let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [
    llm-agents.herdr
    llm-agents.herdr-app
  ];

  # whole dir, since herdr saves files atomically (that would replace per-file links)
  xdg.configFile."herdr-app".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/herdr/herdr-app";
}
