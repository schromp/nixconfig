-- Catppuccin
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

-- Tokyonight
require("tokyonight").setup({
	style = "dark",
	transparent = true,
	sidebars = { "packer", "nvim-tree" },
})

vim.cmd.colorscheme "catppuccin"
