opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true --shows line number of current line

opt.shell = "/bin/fish"

-- tabs
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.softtabstop = 2
opt.smartindent = true

-- line wrapping
opt.wrap = false

--search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

--cursor line
opt.cursorline = true

-- termcolors (need to be disabled for themes)
opt.termguicolors = false
opt.background = "dark"
-- opt.signcolumn = "yes" -- show sign column so that text doesnt shift (?)

opt.scrolloff = 8

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

--split windows
opt.splitright = true
opt.splitbelow = true

-- for which key
opt.timeoutlen = 300

-- cursor
-- opt.guicursor = ""
