{
  inputs,
  pkgs,
  config,
  ...
}: let
  username = config.modules.user.username;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  environment.systemPackages = with pkgs; [age sops gnupg];

  home-manager.users.${username} = {
    imports = [inputs.sops-nix.homeManagerModules.sops];
    sops = {
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
      defaultSopsFile = ../../secrets/secrets.yaml;
      # secrets."sourcegraph".path = "/home/${username}/.config/nvim/.env";
    };
  };
}
