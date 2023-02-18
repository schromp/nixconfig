{ config, pkgs, ... }:
{
  users.users.root.initialPassword = "1234";
  users.users.lk = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
    shell = pkgs.bash;
    initialPassword = "1234";
  };
}
