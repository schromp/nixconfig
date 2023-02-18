local setup, tools = pcall(require, "rust-tools")
if not setup then
	return
end

tools.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", tools.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>a", tools.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
})
