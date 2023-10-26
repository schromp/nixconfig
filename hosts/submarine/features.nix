{...}: {
  imports = [
    ../../modules
    ../../presets
  ];

  config = {
    presets = {};

    programs = {
      installCommon = {
        terminal = true;
      };

      tmux.enable = true;
      zsh.enable = true;
      neovim.enable = true;

      git = {};
    };
  };
}
