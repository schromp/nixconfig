{ config, inputs, pkgs }: {
  
  programs.fuzzel = {
    enable = true;
    settings = ''
      width = 60

      [colors]
      background = 1F1F2800
      text = DCD7BAFF
      match = 957FB8FF
      selection = 223249aa
      selection-match = 957FB8FF
    '';
    };
}
