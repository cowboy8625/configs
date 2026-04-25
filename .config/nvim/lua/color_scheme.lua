vim.pack.add({ GH("NTBBloodbath/doom-one.nvim") })
require("doom-one").setup = function()
  -- Add color to cursor
  vim.g.doom_one_cursor_coloring = true
  -- Set :terminal colors
  vim.g.doom_one_terminal_colors = true
  -- Enable italic comments
  vim.g.doom_one_italic_comments = true
  -- Enable TS support
  vim.g.doom_one_enable_treesitter = true
  -- Color whole diagnostic text or only underline
  vim.g.doom_one_diagnostics_text_color = true
  -- Enable transparent background
  vim.g.doom_one_transparent_background = false

  -- Pumblend transparency
  vim.g.doom_one_pumblend_enable = false
  vim.g.doom_one_pumblend_transparency = 20

  -- Plugins integration
  vim.g.doom_one_plugin_neorg = true
  vim.g.doom_one_plugin_barbar = true
  vim.g.doom_one_plugin_telescope = false
  vim.g.doom_one_plugin_neogit = true
  vim.g.doom_one_plugin_nvim_tree = true
  vim.g.doom_one_plugin_dashboard = true
  vim.g.doom_one_plugin_startify = true
  vim.g.doom_one_plugin_whichkey = true
  vim.g.doom_one_plugin_indent_blankline = true
  vim.g.doom_one_plugin_vim_illuminate = true
  vim.g.doom_one_plugin_lspsaga = true
end
vim.cmd.colorscheme("doom-one")
-- -- theme
-- vim.cmd.colorscheme("habamax")
-- vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
-- -- For transparency
-- -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- -- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
--
-- --=================================================================================================
-- --                             Color Scheme Switcher
-- --=================================================================================================
--
-- local colorschemes = vim.fn.getcompletion("", "color")
-- local current_index = 1
--
-- local function cycle_colorschemes()
--   current_index = current_index + 1
--   if current_index > #colorschemes then
--     current_index = 1
--   end
--   local ok, _ = pcall(vim.cmd.colorscheme, colorschemes[current_index])
--   if not ok then
--     vim.notify("Failed to load colorscheme: " .. colorschemes[current_index], vim.log.levels.ERROR)
--   else
--     vim.notify("Colorscheme: " .. colorschemes[current_index])
--   end
-- end
--
-- vim.keymap.set("n", "<leader>cc", cycle_colorschemes, { desc = "Cycle colorscheme" })
