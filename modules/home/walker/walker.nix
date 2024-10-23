# {
#   inputs,
#   config,
#   lib,
#   ...
# }: let
#   cfg = config.modules.home.programs.walker;
# in {
#   options.modules.home.programs.walker = {
#     enable = lib.mkEnableOption "Enable walker";
#   };
#
#   imports = [inputs.walker.homeManagerModules];
#
#   config = lib.mkIf cfg.enable {
#     # TODO: move this so its actually usable
#     # nix.settings = {
#     #   substituters = ["https://walker.cachix.org"];
#     #   trusted-public-keys = ["walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="];
#     # };
#
#     programs.walker = {
#       enable = true;
#       runAsService = false;
#       config = {
#         list = {
#           height = 300;
#           always_show = false;
#           hide_sub = true;
#         };
#         modules = [
#           {
#             name = "applications";
#             prefix = "";
#           }
#           {
#             name = "runner";
#             prefix = "$";
#           }
#           {
#             name = "websearch";
#             prefix = "?";
#           }
#           {
#             name = "switcher";
#             prefix = "/";
#           }
#           {
#             name = "finder";
#             prefix = "~";
#           }
#           {
#             name = "hyprland";
#             prefix = "-";
#           }
#         ];
#       };
#       style = builtins.readFile ./style.css;
#     };
#   };
# }
{}
