-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- ==== NVIM SHIT ====
local a = wezterm.action
local function is_inside_vim(pane)
  local tty = pane:get_tty_name()
  if tty == nil then return false end
  local success, stdout, stderr = wezterm.run_child_process { 'sh', '-c',
      'ps -o state= -o comm= -t' .. wezterm.shell_quote_arg(tty) .. ' | ' ..
      'grep -iqE \'^[^TXZ ]+ +(\\S+\\/)?g?(view|l?nvim?x?)(diff)?$\'' }
  return success
end
local function is_outside_vim(pane) return not is_inside_vim(pane) end

local function bind_if(cond, key, mods, action)
  local function callback (win, pane)
    if cond(pane) then
      win:perform_action(action, pane)
    else
      win:perform_action(a.SendKey({key=key, mods=mods}), pane)
    end
  end
  return {key=key, mods=mods, action=wezterm.action_callback(callback)}
end

-- ==== NVIM SHIT END ==== 

config.use_fancy_tab_bar = false
config.window_decorations = "NONE"
-- config.color_scheme = "Catppuccin Frappe"
config.colors = wezterm.color.load_base16_scheme("/home/lk/.config/themer/tokyonight.yaml")

-- config.font = wezterm.font 'Iosevka' This doesnt work

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

local act = wezterm.action

config.keys = {

	bind_if(is_outside_vim, "h", "CTRL", act.ActivatePaneDirection("Left")),
	bind_if(is_outside_vim, "j", "CTRL", a.ActivatePaneDirection("Down")),
	bind_if(is_outside_vim, "k", "CTRL", a.ActivatePaneDirection("Up")),
	bind_if(is_outside_vim, "l", "CTRL", a.ActivatePaneDirection("Right")),
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 25 },
		}),
	},
	{
		key = '"',
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

-- and finally, return the configuration to wezterm
return config
