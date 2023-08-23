{ config, pkgs, lib, ... }:
let
  # installs a vim plugin from git with a given tag / branch
  # pluginGit = ref: repo: vimUtils.buildVimPluginFrom2Nix {
  #   pname = "${lib.strings.sanitizeDerivationName repo}";
  #   version = ref;
  #   src = builtins.fetchGit {
  #     url = "https://github.com/${repo}.git";
  #     ref = ref;
  #   };
  # };

  # always installs latest version
  # plugin = pluginGit "HEAD";
in
{

  # dependencies for nvim
  home.packages = with pkgs; [
      ripgrep
      fd
      fzf

      tree-sitter

      # LSPs

      clang-tools
      # rnix-lsp
      nil
      sumneko-lua-language-server
      rust-analyzer
      statix
      nixpkgs-fmt
      nil
      python311Packages.jedi-language-server

   ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
  };


  programs.fzf.enable = true;

}