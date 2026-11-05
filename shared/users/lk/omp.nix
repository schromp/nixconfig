{inputs, ... }: {
  imports = [ inputs.omp.homeManagerModules.default ];
  programs.omp = {
    enable = false;
    settings.startup.quiet = true;
  };
}
