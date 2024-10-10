{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.neovim;
in {
  options.modules.home.programs.neovim.enable = lib.mkEnableOption "Enable neovim";

  config = lib.mkIf cfg.enable {
    # dependencies for nvim
    home.packages = with pkgs; [
      neovide

      ripgrep
      fd
      fzf
      tree-sitter

      clang
      cargo
      rustc
      inputs.rustacean.packages.${pkgs.system}.codelldb
      # gdb # Not supported on darwin

      sassc

      # LSPs
      clang-tools
      nil
      nixd
      sumneko-lua-language-server
      rust-analyzer
      rustfmt
      statix
      nixpkgs-fmt
      python311Packages.jedi-language-server
      alejandra
      nodePackages.bash-language-server

      gopls
      go
      air
      ollama

      stylua
      prettierd
      yamllint
      nodePackages.typescript
      nodePackages.typescript-language-server
      # vscode-langservers-extracted
      texlab
      prettierd
      emmet-ls
      phpactor
    ];

    programs.neovim = {
      enable = true;

      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

      defaultEditor = true;
      withNodeJs = true;
      withPython3 = true;

      extraLuaPackages = luaPkgs: with luaPkgs; [cjson];
    };

    programs.fzf.enable = true;
  };
}
