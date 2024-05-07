{lib, ...}: {
  system = {
    # options.modules.testing = lib.mkEnableOption "";
    # config = {
      programs.fish.enable = true;
    # };
  };

  home = {
    programs.fish.enable = true;
  };
}
