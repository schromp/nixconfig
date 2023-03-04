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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      # here come lsps and other dependencies

      ripgrep
      fd
      fzf

      tree-sitter

      # LSPs
      clang-tools
      rnix-lsp
      sumneko-lua-language-server
      rust-analyzer
    ];

    extraConfig = builtins.concatStringsSep "\n" [
      ''
        lua << EOF
        ${lib.strings.fileContents ./config/config.lua}
        ${lib.strings.fileContents ./config/lsp.lua}
        ${lib.strings.fileContents ./config/plugins.lua}
        ${lib.strings.fileContents ./config/keymap.lua}
        ${lib.strings.fileContents ./config/colorscheme.lua}

        EOF
      ''
    ];

    plugins = with pkgs.vimPlugins; [

      # lsp
      nvim-lspconfig
      lspsaga-nvim
      cmp-nvim-lsp
      nvim-cmp
      null-ls-nvim
      trouble-nvim
      neodev-nvim
      cmp-buffer
      cmp-path
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      yuck-vim
      vim-parinfer

      # themes
      catppuccin-nvim
      tokyonight-nvim

      # utils
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim

      # ui
      nvim-tree-lua
      nvim-web-devicons
      # toggleterm-nvim # this will be replaced with tmux
      vim-tmux-navigator
      todo-comments-nvim
      fidget-nvim
      which-key-nvim
      cheatsheet-nvim
      lualine-nvim
      dashboard-nvim

      # snippets
      luasnip
      friendly-snippets

      # Comments
      DoxygenToolkit-vim
      comment-nvim

      # misc
      crates-nvim
      nvim-navic
      auto-pairs
      leap-nvim
    ];
  };

  programs.fzf.enable = true;

}
