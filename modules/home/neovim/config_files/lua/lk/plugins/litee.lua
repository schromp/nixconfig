local litee_setup, litee = pcall(require, "litee.lib")
if not litee_setup then
	return
end

litee.setup({
	tree = {
		icon_set = "codicons",
	},
	panel = {
		orientation = "right",
		panel_size = 30,
	},
	term = {
		position = "bottom",
		term_size = 15,
	},
})

local filetree_setup, filetree = pcall(require, "litee.filetree")
if not filetree_setup then
	return
end

filetree.setup()

local calltree_setup, calltree = pcall(require, "litee.calltree")
if not calltree_setup then
	return
end

calltree.setup()
