{ config, pkgs, ... }:
let
  emacsWithPackages = pkgs.emacs.pkgs.withPackages (emacsPackages: with emacsPackages; [
    evil-ghostel
    ghostel
    go-template-helper-mode
    vterm
  ]);
in
{
  home.packages = with pkgs; [
    emacsWithPackages
    git
    ripgrep
    coreutils
    fd
    clang
    helm-ls
    kubeconform
    kubernetes-helm
    nil
    yaml-language-server
    yamllint
  ];

  home.file.".config/emacs".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/emacs/config";
}
