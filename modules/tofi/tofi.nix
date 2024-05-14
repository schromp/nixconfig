{
  pkgs,
  lib,
  config,
  ...
}: let
  opts = config.modules.user;
  username = config.modules.user.username;
in {
  options.modules.programs.tofi = {
    runnerScript = lib.mkOption {
      type = with lib.types; package;
    };
  };

  home = {
    config = lib.mkIf (opts.appRunner == "tofi") {
      modules.programs.tofi = {
        runnerScript = import ./runnerScript.nix {inherit pkgs lib;};
      };

      home-manager.users.${username} = {
        home.packages = with pkgs; [
          tofi
        ];
      };
    };
  };
}
