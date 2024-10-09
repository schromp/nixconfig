{
  pkgs,
  config,
  inputs,
  ...
}: {
  config = {
    users.users.lk = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      shell = pkgs.zsh;
      hashedPassword = "$y$j9T$r/yxsyYRlpXXxy0TPtNRC1$.6pBk8mV/f7AEh0bGHkDEJTFK.7rRissy6WGrTafvH1";
      packages = [
      ];
    };

    home-manager.users.lk = {
      home.packages = [];

      home.stateVersion = "24.05";
    };
  };
}
