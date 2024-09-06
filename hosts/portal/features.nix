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
    ../../modules/yazi
    ../../modules/wezterm
    ../../modules/bat
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
      wezterm.enable = true;
      tmux.enable = true;
      zoxide.enable = true;
      yazi.enable = true;
      bat.enable = true;
    };
  };
}
