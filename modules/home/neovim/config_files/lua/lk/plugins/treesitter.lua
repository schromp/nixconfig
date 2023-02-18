-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

treesitter.setup({
    highlight = {
        enable = true,
    },
    indent = { 
        enable = true,
    },
    ensure_installed = {
        -- "json",
        -- "yaml",
        -- "tsx",
        -- "html",
        -- "css",
        -- "markdown",
        -- "bash",
        -- "lua",
        -- "vim",
        -- "dockerfile",
        -- "gitignore",
        -- "rust",
        -- "c",
    }, -- auto install languages
})
