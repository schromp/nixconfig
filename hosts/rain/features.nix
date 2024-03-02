{...}: {
  imports = [
    ../../modules
  ];

  config = {
    modules = {
      user = {
        username = "lk";
      };

      programs = {
        tmux.enable = true;
      };
    };
  };
}
