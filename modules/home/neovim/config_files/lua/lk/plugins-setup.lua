-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

return packer.startup(function(use)
	use("wbthomason/packer.nvim") -- packer manages itself
	use("nvim-lua/plenary.nvim") -- dependecy

	-- themes
  use { 
    'olivercederborg/poimandres.nvim',
    config = function()
      require('poimandres').setup {
        -- leave this setup function empty for default config
        -- or refer to the configuration section
        -- for configuration options
      }
    end
  }
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("folke/tokyonight.nvim")
	use("savq/melange")

	-- use("jasonccox/vim-wayland-clipboard")

	use("numToStr/Comment.nvim") -- comment with gc

	use("nvim-tree/nvim-tree.lua") -- File explorer
	use("kyazdani42/nvim-web-devicons") --vscode icons

	use("nvim-lualine/lualine.nvim") --statusline

	-- use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

	-- TODO: replace this with a better terminal
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
	}) -- Terminal

	use("christoomey/vim-tmux-navigator") -- tmux & split window navigation

	use("szw/vim-maximizer") -- maximizes and restores current window

	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets")
	use("vim-scripts/DoxygenToolkit.vim") -- doxygen generator
	use({
		"saecki/crates.nvim",
		tag = "v0.3.0",
	})

	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({ "glepnir/lspsaga.nvim", branch = "main" }) -- enhanced lsp uis
	use({
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
	})
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	})
	use("j-hui/fidget.nvim")

	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	}) -- highlighting
	use("nvim-treesitter/nvim-treesitter-context") -- shows the functions at top of screen if functions definition outside

	-- use("simrat39/rust-tools.nvim")

	use("folke/neodev.nvim") -- signature helper for nvim configs

	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...

	use("ron-rs/ron.vim") -- ron language

	use("ggandor/leap.nvim") -- leap into code

	use("lewis6991/gitsigns.nvim") -- git: show line modifications on left hand side

	use("norcalli/nvim-colorizer.lua")

	use("folke/which-key.nvim")
	use({
		"sudormrfbin/cheatsheet.nvim",
		requires = {
			{ "nvim-telescope/telescope.nvim" },
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
		},
	})

	-- use("ldelossa/litee.nvim")
	-- use("ldelossa/litee-calltree.nvim")
	-- use("ldelossa/litee-filetree.nvim")
	use("ldelossa/nvim-ide")

	if packer_bootstrap then
		require("packer").sync()
	end
end)
