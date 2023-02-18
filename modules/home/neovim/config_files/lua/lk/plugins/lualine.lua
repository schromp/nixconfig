-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
	return
end

local lualine_nightfly = require("lualine.themes.nightfly")

lualine.setup({
	options = {
		theme = "catppuccin",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
