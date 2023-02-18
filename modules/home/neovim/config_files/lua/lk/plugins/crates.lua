-- import comment plugin safely
local setup, crates = pcall(require, "crates")
if not setup then
	return
end

-- enable comment
crates.setup()
