{inputs, pkgs, config, ...}: {
  home.packages = let
    zellijPkg =
      if pkgs.system == "aarch64-darwin"
      then inputs.nixpkgs.legacyPackages."aarch64-darwin".zellij
      else pkgs.zellij;
  in
    [
      zellijPkg
    ];

  xdg.configFile."zellij/config.kdl".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/zellij/config.kdl";
}
