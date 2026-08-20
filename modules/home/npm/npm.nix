{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.npm;
in {
  options.modules.home.programs.npm = {
    enable = lib.mkEnableOption "Enable npm with NixOS-compatible global prefix";
  };

  config = lib.mkIf cfg.enable {
    # Redirect npm global installs to a writable directory instead of the read-only Nix store
    home.file.".npmrc".text = ''
      prefix = ${config.home.homeDirectory}/.npm-global
    '';

    programs.bash.sessionVariables = {
      PATH = "$PATH:${config.home.homeDirectory}/.npm-global/bin";
    };

    programs.fish.interactiveShellInit = ''
      fish_add_path ${config.home.homeDirectory}/.npm-global/bin
    '';
  };
}
