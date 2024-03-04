{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  opts = config.modules.user;
  username = config.modules.user.username;
in {
  options.modules.programs.tofi = {
    runnerScript = mkOption {
      type = with types; package;
    };
  };

  config = mkIf (opts.homeManager.enabled && opts.appRunner == "tofi") {
    modules.programs.tofi = {
      runnerScript = import ./runnerScript.nix {inherit pkgs lib;};
    };

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        tofi
      ];
    };
  };
}
