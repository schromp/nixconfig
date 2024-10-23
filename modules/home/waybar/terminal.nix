{config}: let
    colors = config.modules.home.general.theme.colorscheme.colors;
in ''
* {
    /* `otf-font-awesome` is required to be installed for icons */
    font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
    font-size: 9px;
    min-height: 0;
}

window#waybar {
    /* background-color: rgba(43, 48, 59, 0.5); */
    background-color: transparent;
    color: #${colors.base05};
    transition-property: background-color;
    transition-duration: .5s;
}

#workspaces button {
    background-color: transparent;
    color: #ffffff;
    padding: 0px;
    margin: 0px;
}

#workspaces button.empty {
    color: #${colors.base03};
}

/* #workspaces button:hover { */
/*   color: #a2dfd3; */
/* } */

#workspaces button.urgent {
    color: #${colors.base09};
}

#workspaces button.active {
    color: #${colors.base0D};
}
''
