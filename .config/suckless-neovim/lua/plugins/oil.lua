vim.pack.add({
  -- Dependency's
  GH("echasnovski/mini.icons"),
  -- Plugin
  GH("stevearc/oil.nvim"),
})

-- Setup
require("mini.icons").setup()
require("oil").setup()

-- Keybindings
vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open file explorer" })
