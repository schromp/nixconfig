{ pkgs, ... }: {

  programs.vesktop = {
    enable = true;
    package = pkgs.vesktop.override {
      pnpm_10_29_2 = pkgs.pnpm_10;
    };
  };
}
