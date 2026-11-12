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
    # the app's wrapper only puts herdr-core on its own PATH; remote (ssh) connections
    # look it up via `command -v herdr-core` in the login shell
    llm-agents.herdr-core
    llm-agents.terminal-browser
  ];

  # whole dir, since herdr saves files atomically (that would replace per-file links)
  xdg.configFile."herdr-app".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/herdr/herdr-app";

  # its skill comes from agent-skills.nix; stop it linking its own on every version bump
  xdg.stateFile."terminal-browser/skills-choice".text = "no\n";

  # herdr-nvim's app mods; herdr-app/mods/herdr-nvim{,-header} are git-tracked symlinks to these
  xdg.dataFile."herdr-nvim/mods".source = "${herdr-nvim}/share/herdr-nvim/mods";
}
