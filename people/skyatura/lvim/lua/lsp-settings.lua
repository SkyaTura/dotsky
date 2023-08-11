require('which-key') -- Key Mapping Helper

-- Convenience mappings
WK_register_leader("l", { R = { "<cmd>LspRestart<cr>", "Restart" } })

-- Setup
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    exe = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
  },
}

-- Diagnostics
--
table.insert(lvim.plugins, {
  "folke/trouble.nvim",
  cmd = "TroubleToggle",
})

vim.g.diagnostics_virtual_text = false
local function set_diagnostics_virtual_text()
  vim.diagnostic.config({ virtual_text = vim.g.diagnostics_virtual_text })
end

function _G.toggle_diagnostics_virtual_text()
  vim.g.diagnostics_virtual_text = not vim.g.diagnostics_virtual_text
  set_diagnostics_virtual_text()
end

set_diagnostics_virtual_text() -- initialize

function _G.diagnostics_handler()
  if vim.g.diagnostics_virtual_text then
    return
  end
  vim.diagnostic.open_float({ focusable = false })
end

vim.cmd [[autocmd CursorHold * lua _G.diagnostics_handler()]]


WK_register_leader("t", {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
  T = { "<cmd>lua _G.toggle_diagnostics_virtual_text()<CR>", "Toggle popup/inline errors" },
  n = lvim.builtin.which_key.mappings["l"]["j"],
})

lvim.builtin.which_key.mappings.l.F = lvim.builtin.which_key.mappings.l.f
lvim.builtin.which_key.mappings.l.f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format buffer" }
