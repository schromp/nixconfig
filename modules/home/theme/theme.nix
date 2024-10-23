{
  lib,
  config,
  ...
}: let
  inherit (lib.options) literalExpression;
  inherit (lib.types) str mkOptionType attrsOf coercedTo;
  inherit (lib.strings) removePrefix hasPrefix isString;

  cfg = config.modules.home.general.theme;

  hexColorType = mkOptionType {
    name = "hex-color";
    descriptionClass = "noun";
    description = "RGB color in hex format";
    check = x: isString x && !(hasPrefix "#" x);
  };
  getPaletteFromScheme = slug:
    if builtins.pathExists ./palettes/${slug}.nix
    then (import ./palettes/${slug}.nix).palette
    else throw "The following colorscheme was imported but not found: ${slug}";
in {
  options.modules.home.general.theme = {
    name = lib.mkOption {
      type = lib.types.str;
    };
    font = lib.mkOption {
      type = lib.types.str;
    };
    colorscheme = {
      name = lib.mkOption {
        type = lib.types.str;
      };
      colors = lib.mkOption {
        type = attrsOf (
          coercedTo str (removePrefix "#") hexColorType
        );
        description = ''
          An attribute set containing active colors of the system. Follows base16
          scheme by default but can be expanded to base24 or anything "above" as
          seen fit as the module option is actually not checked in any way
        '';
        default = getPaletteFromScheme cfg.colorscheme.name;
        example = literalExpression ''
          {
            base00 = "#002635";
            base01 = "#00384d";
            base02 = "#517F8D";
            base03 = "#6C8B91";
            base04 = "#869696";
            base05 = "#a1a19a";
            base06 = "#e6e6dc";
            base07 = "#fafaf8";
            base08 = "#ff5a67";
            base09 = "#f08e48";
            base0A = "#ffcc1b";
            base0B = "#7fc06e";
            base0C = "#14747e";
            base0D = "#5dd7b9";
            base0E = "#9a70a4";
            base0F = "#c43060";
          }
        '';
      };
    };
  };
}
