require("catppuccin").setup({
	flavour = "mocha", -- latte, frappe, macchiato, mocha
	background = { -- :h background
		light = "latte",
		dark = "mocha",
	},
	transparent_background = true,
	term_colors = false,
	color_overrides = {
		all = {
			surface2 = "#7B7C87",
		},
	},
})

-- require("poimandres").setup({
--	disable_background = true,
-- })

-- require("leaf").setup({
-- transparent = true,
-- theme = "auto",
-- })

require("tokyonight").setup({
	style = "dark",
	transparent = true,
	sidebars = { "packer", "nvim-tree" },
})

-- set colorscheme to nightfly with protected call
-- in case it isn't installed
local status, _ = pcall(vim.cmd, "colorscheme catppuccin")
if not status then
	print("Colorscheme not found!") -- print error if colorscheme not installed
	return
end
