{lib, ...}: {
  options.home.flakePath = lib.mkOption {
    type = lib.types.str;
  };
}
