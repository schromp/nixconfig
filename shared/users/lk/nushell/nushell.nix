{
  pkgs,
  ...
}:
let
in
{
  home.packages = with pkgs; [
    nushell
    fish
  ];

  xdg.configFile."nushell/config.nu".text = builtins.readFile ./config.nu;
  xdg.configFile."nushell/zoxide.nu".text = builtins.readFile ./zoxide.nu;
}
