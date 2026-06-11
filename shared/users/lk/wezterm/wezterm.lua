local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.use_fancy_tab_bar = false
config.tab_max_width = 64
config.enable_tab_bar = true

config.font = wezterm.font("Hurmit Nerd Font")

config.font_size = 13
config.audible_bell = "Disabled"

config.color_scheme = "catppuccin-mocha"
config.window_background_opacity = 0.8

config.leader = { key = "a", mods = "CTRL" }
config.keys = {
	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },

	{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
	{ key = "6", mods = "ALT", action = act.ActivateTab(5) },
	{ key = "7", mods = "ALT", action = act.ActivateTab(6) },
	{ key = "8", mods = "ALT", action = act.ActivateTab(7) },
	{ key = "9", mods = "ALT", action = act.ActivateTab(8) },
	{ key = "0", mods = "ALT", action = act.ActivateTab(9) },

	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "pane",
			timeout_milliseconds = 1000,
		}),
	},
	{
		key = "t",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "tab",
			timeout_milliseconds = 1000,
		}),
	},
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize",
			one_shot = false,
		}),
	},
}

config.key_tables = {
	resize = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		{ key = "Escape", action = "PopKeyTable" },
	},

	pane = {
		{ key = "n", action = act.SplitPane({ direction = "Right" }) },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
	},
	tab = {
		{ key = "n", action = act.SpawnTab("CurrentPaneDomain") },
	},
}

return config
