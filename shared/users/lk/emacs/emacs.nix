{ pkgs, ... }: {
  home.packages = with pkgs; [
    emacs
    git
    ripgrep
    coreutils
    fd
    clang
    emacsPackages.vterm
  ];
}
