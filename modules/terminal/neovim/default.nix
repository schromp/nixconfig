{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.terminal.neovim;
in {
  options.modules.terminal.neovim.enable = mkEnableOption "Enable neovim";

  config = mkIf cfg.enable {
    # dependencies for nvim
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        neovide

        ripgrep
        fd
        fzf
        tree-sitter

        # LSPs
        clang-tools
        nil
        sumneko-lua-language-server
        rust-analyzer
        statix
        nixpkgs-fmt
        nil
        python311Packages.jedi-language-server
        alejandra
      ];

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        withNodeJs = true;
        withPython3 = true;
      };

      programs.fzf.enable = true;
    };
  };
}
