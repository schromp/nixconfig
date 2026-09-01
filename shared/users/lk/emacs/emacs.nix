{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    emacs
    git
    ripgrep
    coreutils
    fd
    clang
    emacsPackages.vterm
    nil
  ];

  home.file.".config/emacs".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/emacs/config";
}
