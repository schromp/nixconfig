{
  config,
  pkgs,
  inputs,
  ...
}:
let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  herdr-nvim = pkgs.callPackage ./herdr-nvim.nix { };

  # terminal-browser's terminal API for the Herdr app (it only knows the herdr TUI, and
  # herdr-core terminals claim TERM_PROGRAM=ghostty): splits, `ls`, send-to-agent, focus
  tb-socket = "terminal-browser-herdr.sock";
  tb-adapter = pkgs.writeShellApplication {
    name = "terminal-browser-herdr";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.jq
      pkgs.procps
      pkgs.wl-clipboard
      llm-agents.herdr-core
      llm-agents.herdr-app
    ];
    bashOptions = [ ]; # handles its own failures, replying with an error
    text = builtins.readFile ./terminal-browser-herdr.sh;
  };
  # use the adapter only inside herdr-app terminals (not plain Ghostty, not the herdr TUI)
  terminal-browser = pkgs.writeShellScriptBin "terminal-browser" ''
    sock="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/${tb-socket}"
    if [ -n "''${HC_TERMINAL_SOCKET:-}" ] && [ -z "''${HERDR_PANE_ID:-}" ] \
      && [ -z "''${TERMINAL_BROWSER_TERMINAL_SOCKET:-}" ] && [ -S "$sock" ]; then
      export TERMINAL_BROWSER_TERMINAL_SOCKET="$sock"
    fi
    exec ${llm-agents.terminal-browser}/bin/terminal-browser "$@"
  '';
in
{
  home.packages = [
    llm-agents.herdr
    llm-agents.herdr-app
    # the app's wrapper only puts herdr-core on its own PATH; remote (ssh) connections
    # look it up via `command -v herdr-core` in the login shell
    llm-agents.herdr-core
    terminal-browser
  ];

  systemd.user.services.terminal-browser-herdr = {
    Unit = {
      Description = "terminal-browser terminal API for the Herdr app";
      # sendText goes through the Wayland clipboard
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Environment = [ "TERMINAL_BROWSER_TERMINAL_SOCKET=%t/${tb-socket}" ];
      ExecStart = "${pkgs.socat}/bin/socat UNIX-LISTEN:%t/${tb-socket},fork,unlink-early,mode=600 EXEC:${tb-adapter}/bin/terminal-browser-herdr";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # whole dir, since herdr saves files atomically (that would replace per-file links)
  xdg.configFile."herdr-app".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/herdr/herdr-app";

  # its skill comes from agent-skills.nix; stop it linking its own on every version bump
  xdg.stateFile."terminal-browser/skills-choice".text = "no\n";

  # herdr-nvim's app mods; herdr-app/mods/herdr-nvim{,-header} are git-tracked symlinks to these
  xdg.dataFile."herdr-nvim/mods".source = "${herdr-nvim}/share/herdr-nvim/mods";
}
