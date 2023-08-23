{ ... }: {
  imports = [
    ../../modules
    ../../presets
  ];

  config = {
    modules = {
      user = {
        username = "lennartkoziollek";
      };
      system = {
        nvidia = false;
      };
    };
  };
}
