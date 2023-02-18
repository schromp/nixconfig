require('todo-comments').setup()
require('fidget').setup()
require('which-key').setup()
require('cheatsheet').setup()
require('Comment').setup()
require('crates').setup()

-- Telescope
local telescope = require('telescope')
local telescope_actions = require("telescope.actions")
telescope.setup {
    defaults = {
        mappings = {
          n = {
            ["<C-q>"] = telescope_actions.send_selected_to_qflist + telescope_actions.open_qflist, -- send selected to quickfixlist
          },
          i = {
            ["<C-k>"] = telescope_actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = telescope_actions.move_selection_next, -- move to next result
          }
        }
    }
}

telescope.load_extension('fzf')

-- Nvim tree
local nvimtree = require('nvim-tree')
nvimtree.setup {
    renderer = {
        icons = {
            glyphs = {
                folder = {
                    arrow_closed = "", -- arrow when folder is closed
                    arrow_open = "", -- arrow when folder is open
                },
            },
        },
    },
    -- disable window_picker for
    -- explorer to work well with
    -- window splits
    actions = {
        open_file = {
            window_picker = {
                enable = false,
            },
        },
    },
}

-- Lualine
local lualine = require('lualine')
lualine.setup {
    options = {
        theme = "catppuccin"
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diagnostics', 'searchcount' },
        lualine_c = { 'filename' },
        lualine_x = { 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}

-- Autopairs
local autopairs = require('nvim-autopairs')
autopairs.setup {
  check_ts = true, -- enable treesitter
  ts_config = {
    lua = { "string" }, -- dont add pairs in lua strings
  }
}
local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
