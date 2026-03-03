{pkgs, ...}: {
  home.packages = [ pkgs.k9s ];

  xdg.configFile."k9s/config.yaml".text = ''
    k9s:
      ui:
        skin: matugen_skin.yaml
  '';
}
