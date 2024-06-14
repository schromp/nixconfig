{...}: {
  imports = [
    # ../../presets

    ../../modules/options/user.nix
    ../../modules/options/system.nix

    ../../modules/themer
    ../../modules/zsh
    ../../modules/neovim
    ../../modules/kitty
    ../../modules/tmux
    ../../modules/zoxide
  ];

  config.modules = {
    user = {
      username = "lennart.koziollek";
    };
    system = {
      hostname = "M65L7Q9X32";
    };
    programs = {
      themer.enable = true;
      zsh = {
        enable = true;
      };
      neovim.enable = true;
      kitty.enable = true;
      tmux.enable = true;
      zoxide.enable = true;
    };
  };
}
