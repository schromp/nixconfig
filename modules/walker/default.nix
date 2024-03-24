{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  opts = config.modules.user;
in {
  config = mkIf (opts.homeManager.enabled && opts.appRunner == "walker") {
    home-manager.users.${username} = {
      home.packages = [inputs.walker.packages.${pkgs.system}.default];
    };
  };
}
