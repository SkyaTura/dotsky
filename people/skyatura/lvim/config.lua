-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

require('aesthetics')   -- Dashboard, NeoTree
require('lsp-settings') -- Eslint, Diagnostics


-- LSP Settings

lvim.builtin.which_key.mappings["\\"] = {
  name = "Deeper leader",
}
lvim.builtin.which_key.mappings["\\"]["\\"] = { "<cmd>w<cr>", "Save file" }



table.insert(lvim.plugins, {
  "windwp/nvim-spectre",
  event = "BufRead",
  config = function()
    require("spectre").setup()
  end,
})

table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
      require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
    end, 100)
  end,
})

table.insert(lvim.plugins, {
  "RishabhRD/nvim-cheat.sh",
  dependencies = { "RishabhRD/popfix" },
})

-- table.insert(lvim.plugins, { "danilamihailov/vim-tips-wiki" })

table.insert(lvim.plugins, {
  "chrisgrieser/nvim-various-textobjs",
  opts = { useDefaultKeymaps = true },
})

-- table.insert(lvim.plugins, {
--   "chrisgrieser/nvim-spider",
--   init = function()
--     vim.keymap.set({ "n", "o", "x" }, "ew", "<>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
--     vim.keymap.set({ "n", "o", "x" }, "ee", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
--     vim.keymap.set({ "n", "o", "x" }, "eb", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
--     vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
--   end,
--   opts = {
--     skipInsignificantPunctuation = false,
--   },
-- })

-- table.insert(lvim.plugins, {
--   'rmagatti/auto-session',
--   config = function()
--     require("auto-session").setup {
--       log_level = "error",
--       auto_session_suppress_dirs = { "~/", "~/projects", "~/Downloads", "/" },
--     }
--   end,
-- })

table.insert(lvim.plugins, {
  "ggandor/leap.nvim",
  name = "leap",
  config = function()
    require("leap").add_default_mappings()
  end,
})

table.insert(lvim.plugins, {
  "nacro90/numb.nvim",
  event = "BufRead",
  config = function()
    require("numb").setup {
      show_numbers = true,    -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
    }
  end,
})

table.insert(lvim.plugins, {
  "kevinhwang91/nvim-bqf",
  event = { "BufRead", "BufNew" },
  config = function()
    require("bqf").setup({
      auto_enable = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
      },
      func_map = {
        vsplit = "",
        ptogglemode = "z,",
        stoggleup = "",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    })
  end,
})


--table.insert(lvim.plugins, {
--  "andymass/vim-matchup",
--   event = "CursorMoved",
--  config = function()
--    vim.g.matchup_matchparen_offscreen = { method = "popup" }
--  end,
--})
-- enable treesitter integration
--lvim.builtin.treesitter.matchup.enable = true

table.insert(lvim.plugins, {
  "f-person/git-blame.nvim",
  event = "BufRead",
  config = function()
    vim.cmd "highlight default link gitblame SpecialComment"
    vim.g.gitblame_enabled = 0
  end,
})

table.insert(lvim.plugins, {
  "ruifm/gitlinker.nvim",
  event = "BufRead",
  config = function()
    require("gitlinker").setup {
      opts = {
        -- remote = 'github', -- force the use of a specific remote
        -- adds current line nr in the url for normal mode
        add_current_line_on_normal_mode = true,
        -- callback for what to do with the url
        action_callback = require("gitlinker.actions").open_in_browser,
        -- print the url after performing the action
        print_url = false,
        -- mapping to call url generation
        mappings = "<leader>gy",
      },
    }
  end,
  dependencies = "nvim-lua/plenary.nvim",
})

table.insert(lvim.plugins, {
  "romgrk/nvim-treesitter-context",
  config = function()
    require("treesitter-context").setup {
      enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
      throttle = true, -- Throttles plugin updates (may improve performance)
      max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
      patterns = {
        -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
          'class',
          'function',
          'method',
        },
      },
    }
  end
})

table.insert(lvim.plugins, {
  "rmagatti/goto-preview",
  config = function()
    require('goto-preview').setup {
      width = 120,              -- Width of the floating window
      height = 25,              -- Height of the floating window
      default_mappings = false, -- Bind default mappings
      debug = false,            -- Print debug information
      opacity = nil,            -- 0-100 opacity level of the floating window where 100 is fully transparent.
      post_open_hook = nil      -- A function taking two arguments, a buffer and a window to be ran as a hook.
      -- You can use "default_mappings = true" setup option
      -- Or explicitly set keybindings
      -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
      -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
      -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
    }
  end
})

table.insert(lvim.plugins, {
  "ahmedkhalf/lsp-rooter.nvim",
  event = "BufRead",
  config = function()
    require("lsp-rooter").setup()
  end,
})

table.insert(lvim.plugins, {
  "ray-x/lsp_signature.nvim",
  event = "BufRead",
  config = function() require "lsp_signature".on_attach() end,
})

table.insert(lvim.plugins, {
  "simrat39/symbols-outline.nvim",
  config = function()
    require('symbols-outline').setup()
  end
})
lvim.builtin.which_key.mappings["S"] = { "<cmd>SymbolsOutline<CR>", "Toggle SymbolsOutline" }

table.insert(lvim.plugins, {
  "folke/todo-comments.nvim",
  event = "BufRead",
  config = function()
    require("todo-comments").setup()
  end,
})

table.insert(lvim.plugins, { "tpope/vim-repeat" })

table.insert(lvim.plugins, { "jbyuki/instant.nvim" })
vim.g.instant_username = "skya"

table.insert(lvim.plugins, { "tpope/vim-surround" })

table.insert(lvim.plugins, { "wakatime/vim-wakatime" })

table.insert(lvim.plugins, {
  "cbochs/portal.nvim",
  -- Optional dependencies
  dependencies = {
    "cbochs/grapple.nvim",
    "ThePrimeagen/harpoon"
  },
})
lvim.builtin.which_key.mappings["\\"]["p"] = {
  name = "Portal",
  p = { "<cmd>Portal jumplist backward<cr>", "Jumplist backward" },
  P = { "<cmd>Portal jumplist forward<cr>", "Jumplist forward" },
  c = { "<cmd>Portal changelist backward<cr>", "Changelist backward" },
  C = { "<cmd>Portal changelist forward<cr>", "Changelist forward" },
  q = { "<cmd>Portal quickfix backward<cr>", "Quickfix backward" },
  Q = { "<cmd>Portal quickfix forward<cr>", "Quickfix forward" },
  h = { "<cmd>Portal harpoon backward<cr>", "Harpoon backward" },
  H = { "<cmd>Portal harpoon forward<cr>", "Harpoon forward" },
  g = { "<cmd>Portal grapple backward<cr>", "Grapple backward" },
  G = { "<cmd>Portal grapple forward<cr>", "Grapple forward" },
}

-- table.insert(lvim.plugins, {
--   "thibthib18/mongo-nvim",
--   build = "luarocks install lua-mongo",
--   config = function()
--     require("mongo-nvim").setup({
--       connection_string = "mongodb://root:example@10.10.3.3:27060/?authSource=admin",
--     })
--   end
-- })
-- lvim.builtin.which_key.mappings["\\"]["m"] = {
--   name = "Mongo",
--   l = { "<cmd>lua require('mongo-nvim.telescope.pickers').database_picker()<cr>", "List available databases" },
--   c = { "<cmd>lua require('mongo-nvim.telescope.pickers').collection_picker('examples')<cr>", "List collections" },
--   d = { "<cmd>lua require('mongo-nvim.telescope.pickers').document_picker('examples', 'movies')<cr>", "List documents" },
-- }

table.insert(lvim.plugins, {
  "rest-nvim/rest.nvim",
  config = function()
    require("rest-nvim").setup({
      result_split_horizontal = true
    })
  end
})
lvim.builtin.which_key.mappings["\\"]["h"] = {
  name = "HTTP",
  h = { "<Plug>RestNvim", "Run" },
  p = { "<Plug>RestNvimPreview", "Preview" },
  l = { "<Plug>RestNvimLast", "Re-run last" },
}

table.insert(lvim.plugins, {
  "knubie/vim-kitty-navigator",
  build = 'cp ./*.py ~/.config/kitty/',
})

table.insert(lvim.plugins, { "ray-x/aurora" })
table.insert(lvim.plugins, {
  "cpea2506/one_monokai.nvim",
  config = function()
    require("one_monokai").setup({
      transparent = true,
    })
  end,
})
table.insert(lvim.plugins, { 'Everblush/nvim', name = 'everblush' })
lvim.colorscheme = "one_monokai"
lvim.transparent_window = true

table.insert(lvim.plugins, { "olacin/telescope-gitmoji.nvim" })

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
  pcall(telescope.load_extension, "neoclip")
  -- any other extensions loading
  pcall(telescope.load_extension, "gitmoji")
end

vim.opt.relativenumber = true -- relative line numbers
vim.opt.clipboard = ""

lvim.leader = "\\"
lvim.format_on_save.enabled = true

lvim.builtin.which_key.mappings["L"]["c"] = { "<cmd>vsplit ~/.config/lvim/config.lua<cr>", "Edit config.lua" }

vim.opt.showcmd = true

lvim.format_on_save.enabled = true

require("rust")

lvim.builtin.which_key.mappings["H"] = { "iospijadoipsjfioasdjfo asopidfjasodifjoi\nhello Mundo0ciwFookf x~0~ysiw[",
  "Edit config.lua" }
