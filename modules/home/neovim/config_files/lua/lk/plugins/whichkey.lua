local status, whichkey = pcall(require, "whichkey_setup")
if not status then
	return
end

whichkey.setup({})

-- whichkey.config({
-- 	hide_statusline = true,
-- 	default_keymap_settings = {
-- 		silent = true,
-- 		noremap = true,
-- 	},
-- 	default_mode = "n",
-- })

-- local keymap = {
-- 	g = {
-- 		name = "+definitions",
-- 		f = "show definitions",
-- 		D = "goto decleration",
-- 		d = "see definition and edit",
-- 		i = "goto implementation",
-- 	},
-- }
--
-- -- local empty = {}
--
-- whichkey.register_keymap("leader", keymap)
