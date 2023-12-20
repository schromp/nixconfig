{
  inputs,
  pkgs,
  config,
  ...
}: let
  opts = config.modules.user;
  username = opts.username;
in {
  home-manager.users.${username} = {
    # add the home manager module
    imports = [inputs.ags.homeManagerModules.default];

    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      # configDir = ../ags;

      # packages to add to gjs's runtime
      extraPackages = [pkgs.libsoup_3];
    };
  };
}
