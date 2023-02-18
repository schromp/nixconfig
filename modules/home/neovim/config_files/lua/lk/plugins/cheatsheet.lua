-- import nvim-autopairs safely
local cheatsheet_setup, cheatsheet = pcall(require, "cheatsheet")
if not cheatsheet_setup then
	return
end

cheatsheet.setup({})
