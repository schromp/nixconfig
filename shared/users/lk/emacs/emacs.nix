{
  inputs,
  config,
  pkgs,
  ...
}:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      # package = pkgs.emacs-git-pgtk;

      config = ./config/init.el;

      extraEmacsPackages =
        epkgs: with epkgs; [
          auctex
          evil-ghostel
          ghostel
          go-template-helper-mode
          pdf-tools
          vterm
          spacious-padding
          mixed-pitch
          olivetti
        ];
    };
  };

  services.emacs.enable = true;

  home.packages = with pkgs; [
    git
    ripgrep
    coreutils
    fd
    clang
    gopls
    helm-ls
    kubeconform
    kubernetes-helm
    nil
    yaml-language-server
    yamllint
    (texlive.combine {
      inherit (texlive.pkgs)
        scheme-medium
        latexmk
        biber
        collection-latexextra
        collection-mathscience
        ;
    })

    # Fonts
    jetbrains-mono
    inter
    nerd-fonts.jetbrains-mono
  ];

  home.file.".config/emacs".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/emacs/config";
}
