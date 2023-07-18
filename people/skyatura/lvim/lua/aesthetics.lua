-- Dashboard
lvim.builtin.alpha.dashboard.section.header.val = {
  [[  ______     __  __     __  __     ______        ]],
  [[ /\  ___\   /\ \/ /    /\ \_\ \   /\  __ \       ]],
  [[ \ \___  \  \ \  _"-.  \ \____ \  \ \  __ \      ]],
  [[  \/\_____\  \ \_\ \_\  \/\_____\  \ \_\ \_\     ]],
  [[   \/_____/   \/_/\/_/   \/_____/   \/_/\/_/     ]],
  [[       ______    __  __     ______     ______    ]],
  [[      /\__  _\  /\ \/\ \   /\  == \   /\  __ \   ]],
  [[      \/_/\ \/  \ \ \_\ \  \ \  __<   \ \  __ \  ]],
  [[         \ \_\   \ \_____\  \ \_\ \_\  \ \_\ \_\ ]],
  [[          \/_/    \/_____/   \/_/ /_/   \/_/\/_/ ]],
  [[                                                 ]],
}

lvim.builtin.alpha.dashboard.section.footer.val = {
  [[  ____ ____ ____ ____  ]],
  [[ ||l |||v |||i |||m || ]],
  [[ ||__|||__|||__|||__|| ]],
  [[ |/__\|/__\|/__\|/__\| ]],
  [[                       ]],
}

-- NeoTree
table.insert(lvim.plugins, {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v2.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local function getTelescopeOpts(state, path)
      return {
        cwd = path,
        search_dirs = { path },
        attach_mappings = function(prompt_bufnr, map)
          local actions = require "telescope.actions"
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local action_state = require "telescope.actions.state"
            local selection = action_state.get_selected_entry()
            local filename = selection.filename
            if (filename == nil) then
              filename = selection[1]
            end
            -- any way to open the file without triggering auto-close event of neo-tree?
            require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
          end)
          return true
        end
      }
    end
    require("neo-tree").setup({
      close_if_last_window = true,
      respect_gitignore = true,
      window = { width = 30 },
      buffers = { follow_current_file = true },
      sources = { "filesystem", "git_status", "buffers", "document_symbols" }, -- NOTE: I'm declaring this to enable symbols navigation
      source_selector = { winbar = true, statusline = false },
      filesystem = {
        follow_current_file = false,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { "node_modules" },
          never_show = { ".DS_Store", "thumbs.db" },
        },
        window = {
          mappings = {
            ["tf"] = "telescope_find",
            ["tg"] = "telescope_grep",
          },
        },
        commands = {
          telescope_find = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require('telescope.builtin').find_files(getTelescopeOpts(state, path))
          end,
          telescope_grep = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
          end,
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function(file_path)
            require("neo-tree.command").execute({ action = "close" })
          end
        },
      },
    })
  end
})
lvim.builtin.nvimtree.active = false -- NOTE: prevent nvimtree to be used
lvim.builtin.which_key.mappings["g"]["m"] = { "<cmd>Telescope gitmoji<CR>", "Commit with gitmoji" }
lvim.builtin.which_key.mappings["e"] = {
  name = "NeoTree",
  e = { "<cmd>NeoTreeRevealToggle<CR>", "Toggle FileSystem" },
  f = { "<cmd>NeoTreeFloat filesystem<CR>", "Explore FileSystem" },
  g = { "<cmd>NeoTreeFloat git_status<CR>", "Explore git status" },
  b = { "<cmd>NeoTreeFloat buffers<CR>", "Explore buffers" },
  s = { "<cmd>NeoTreeFloat document_symbols<CR>", "Toggle document symbols" },
}
