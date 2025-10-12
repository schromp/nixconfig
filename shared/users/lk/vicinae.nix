{ inputs, pkgs, ... }:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  services.vicinae = {
    enable = true;
    autoStart = true;
    package = inputs.vicinae.packages.${pkgs.system}.default;
    extensions = [
      (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
        inherit pkgs;
        name = "test-extension";
        src =
          pkgs.fetchFromGitHub {
            owner = "schromp";
            repo = "vicinae-extensions";
            rev = "f8be5c89393a336f773d679d22faf82d59631991";
            sha256 = "sha256-zk7WIJ19ITzRFnqGSMtX35SgPGq0Z+M+f7hJRbyQugw=";
          }
          + "/test-extension";
      })
      (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
        inherit pkgs;
        name = "swww-switcher";
        src = pkgs.fetchFromGitHub {
          owner = "ViSovereign";
          repo = "swww-switcher";
          rev = "e29515ed74e27e58a631b2d2863bff19941b0c43";
          sha256 = "sha256-g+GNKwXNIuhnQ9u5C/wnp5KLwackF+FdOYXFiYk8WSI=";
        };
      })
    ];
  };
}
