-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.use_fancy_tab_bar = false
config.tab_max_width = 64
config.enable_tab_bar = false

config.font = wezterm.font('Iosevka Nerd Font') -- This doesnt work

config.font_size = 13
config.audible_bell = "Disabled"

-- and finally, return the configuration to wezterm
return config
