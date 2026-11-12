{
  config,
  pkgs,
  inputs,
  ...
}:
let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  herdr-nvim = pkgs.callPackage ./herdr-nvim.nix { };
in
{
  home.packages = [
    llm-agents.herdr
    llm-agents.herdr-app
    llm-agents.terminal-browser
  ];

  # whole dir, since herdr saves files atomically (that would replace per-file links)
  xdg.configFile."herdr-app".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/herdr/herdr-app";

  # herdr-nvim's app mods; herdr-app/mods/herdr-nvim{,-header} are git-tracked symlinks to these
  xdg.dataFile."herdr-nvim/mods".source = "${herdr-nvim}/share/herdr-nvim/mods";
}
