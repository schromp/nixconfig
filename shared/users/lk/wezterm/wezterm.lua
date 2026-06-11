-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.use_fancy_tab_bar = false
config.tab_max_width = 64
config.enable_tab_bar = false

config.font = wezterm.font('Hurmit Nerd Font') -- This doesnt work

config.font_size = 13
config.audible_bell = "Disabled"

config.color_scheme = 'catppuccin-mocha'
config.window_background_opacity = 0.8

config.leader = { key  = "a", mods = "CTRL" }
config.keys = {
  {
    key = '',
    mods = 'LEADER',
    action = wezterm.action({ SendString = '\x1b' }),
  }
}

-- and finally, return the configuration to wezterm
return config
