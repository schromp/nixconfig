local k = vim.keymap

-- leader key
vim.g.mapleader = " "

-- GENERAL

-- jk exit insert
k.set("i", "jk", "<ESC>")

-- delete single char without yank
k.set("n", "x", '"_x"')

-- 0 equals first word
k.set("n", "0", "^")

-- move visual code
k.set("v", "J", ":m '>+1<CR>gv=gv")
k.set("v", "K", ":m '<-2<CR>gv=gv")

-- better search
k.set("n", "n", "nzzzv")
k.set("n", "N", "Nzzzv")

-- window management (just keynotes for now)
-- Ctrl-w v -> vertical split
-- Crtl-w s -> horizontal split
-- Ctrl-w = -> equal size
-- :close -> close window
k.set("n", "<C-right>", ":vertical resize +5<cr>")
k.set("n", "<C-left>", ":vertical resize -5<cr>")
k.set("n", "<C-up>", ":resize +5<cr>")
k.set("n", "<C-down>", ":resize -5<cr>")

-- scrolling
k.set("n", "<C-d>", "<C-d>zz")
k.set("n", "<C-u>", "<C-u>zz")

k.set("n", "L", ":tabn<CR>")
k.set("n", "H", ":tabp<CR>")

-- PLUGIN KEYBINDS
k.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer
k.set("n", "<leader>pv", vim.cmd.Ex) -- toggle file explorer

-- telescope
k.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
k.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
k.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
k.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
k.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

k.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

k.set("n", "<C-t>", ":ToggleTerm<CR>")

k.set("n", "<leader>h", ":nohlsearch<CR>")
