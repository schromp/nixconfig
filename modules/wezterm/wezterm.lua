-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- ==== NVIM SHIT ====
local a = wezterm.action
local function is_inside_vim(pane)
	local tty = pane:get_tty_name()
	if tty == nil then
		return false
	end
	local success, stdout, stderr = wezterm.run_child_process({
		"sh",
		"-c",
		"ps -o state= -o comm= -t"
			.. wezterm.shell_quote_arg(tty)
			.. " | "
			.. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?nvim?x?)(diff)?$'",
	})
	return success
end
local function is_outside_vim(pane)
	return not is_inside_vim(pane)
end

local function bind_if(cond, key, mods, action)
	local function callback(win, pane)
		if cond(pane) then
			win:perform_action(action, pane)
		else
			win:perform_action(a.SendKey({ key = key, mods = mods }), pane)
		end
	end
	return { key = key, mods = mods, action = wezterm.action_callback(callback) }
end

-- ==== NVIM SHIT END ====

config.use_fancy_tab_bar = false
config.tab_max_width = 64
-- config.window_decorations = "NONE"
-- config.color_scheme = "Catppuccin Frappe"
config.colors = wezterm.color.load_base16_scheme("Users/lennart.koziollek/.config/themer/tokyonight.yaml")

-- config.font = wezterm.font 'Iosevka' This doesnt work

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

local act = wezterm.action

config.keys = {

	bind_if(is_outside_vim, "h", "CTRL", act.ActivatePaneDirection("Left")),
	bind_if(is_outside_vim, "j", "CTRL", a.ActivatePaneDirection("Down")),
	bind_if(is_outside_vim, "k", "CTRL", a.ActivatePaneDirection("Up")),
	bind_if(is_outside_vim, "l", "CTRL", a.ActivatePaneDirection("Right")),
	{
		key = '"',
		mods = "LEADER|SHIFT",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 25 },
		}),
	},
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 25 },
		}),
	},
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "z",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
	{ key = "R", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
	-- F1 through F8 to activate that tab
	table.insert(config.keys, {
		key = "F" .. tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

config.font_size = 16
config.audible_bell = "Disabled"

local function tab_title_format(title) 
  return " [" .. title .. "] "
end

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
	local pane = tab.active_pane
	local original_title = tab.tab_title
	local prefix = tab.tab_index + 1 .. ": "

  local title = ""

  -- if the tab title is explicitly set, take that
  if original_title and #original_title > 0 then
    title = original_title
  else
    title = tab.active_pane.title
  end

	if string.match(title, "nvim") then
    local full_path = tostring(pane.current_working_dir.file_path)
    local dir = full_path:match("([^/]+)/?$")
		title = tab_title_format(prefix .. " " .. dir)
	else
		title = tab_title_format(prefix .. title)
	end

	return title
end)

-- and finally, return the configuration to wezterm
return config
