{ config
, pkgs
, lib
, ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.neovim;
in
{
  options.modules.programs.neovim.enable = mkEnableOption "Enable neovim";

  config = mkIf cfg.enable {
    # dependencies for nvim
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        neovide

        ripgrep
        fd
        fzf
        tree-sitter

        clang

        sassc

        # LSPs
        clang-tools
        nil
        # nixd
        sumneko-lua-language-server
        rust-analyzer
        statix
        nixpkgs-fmt
        python311Packages.jedi-language-server
        alejandra

        gopls
        go
        air

        stylua
        prettierd
        yamllint
        nodePackages.typescript
        nodePackages.typescript-language-server
        vscode-langservers-extracted
        texlab
        prettierd
        emmet-ls
      ];

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        withNodeJs = true;
        withPython3 = true;
      };

      programs.fzf.enable = true;
    };
    programs.npm.enable = true;
  };
}
