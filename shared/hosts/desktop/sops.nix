{ ... }:
{
  sops.defaultSopsFile = ../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/lk/.config/sops/age/keys.txt"; # TODO: generic for macos aswell

  sops.secrets."grafana-service-account" = { 
    owner = "lk";
  };
}
