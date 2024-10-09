{
  pkgs,
  config,
  inputs,
  ...
}: {
  config = {
    users.users.lks = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      shell = pkgs.zsh;
      hashedPassword = "$y$j9T$r/yxsyYRlpXXxy0TPtNRC1$.6pBk8mV/f7AEh0bGHkDEJTFK.7rRissy6WGrTafvH1";
      packages = [
      ];
    };

    # TODO: move this
    programs = {
      git = {
        enable = true;
        lfs = {
          enable = true;
        };

        userName = "Lennart Koziollek";
        userEmail = "lennart.koziollek@stud.uni-due.de";
        extraConfig = {
          init.defaultBranch = "main";
        };
      };
      gh = {
        enable = true;
      };
    };

    home-manager.users.lks = {
      home.packages = [];

      home.stateVersion = "24.05";
    };
  };
}
